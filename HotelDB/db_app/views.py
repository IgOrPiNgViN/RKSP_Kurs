from django.shortcuts import render, redirect
from django.db import connection
from django.core.paginator import Paginator
from django.shortcuts import render, get_object_or_404
from django.forms import modelform_factory
from .models import *  # Импортируем все модели
from django.http import Http404, HttpResponseNotFound
from django.contrib.auth.decorators import login_required
from django.forms.models import model_to_dict
from rest_framework import generics, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .serializers import RegisterSerializer, UserSerializer, RoomSerializer, UsersRegisterSerializer, UsersProfileUpdateSerializer, BookingSerializer
from django.contrib.auth.models import User
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from datetime import date
from django.views.generic import ListView
from django import forms
from .forms import GuestBookingForm
import uuid
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.tokens import UntypedToken
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from django.contrib.auth import logout, authenticate, login
from django.contrib import messages


EXCLUDED_TABLES = [
    'auth_user', 'auth_group', 'auth_permission', 'django_migrations', 
    'django_content_type', 'django_session', 'django_admin_log',
    'auth_group_permissions', 'auth_user_groups', 'auth_user_user_permissions'
]


def list_tables(request):
    """Вывод списка пользовательских таблиц в базе данных, исключая системные."""
    with connection.cursor() as cursor:
        cursor.execute("SHOW TABLES;")
        all_tables = [row[0] for row in cursor.fetchall()]

    # Исключаем стандартные Django-таблицы
    user_tables = [table for table in all_tables if table not in EXCLUDED_TABLES]

    return render(request, 'db_app/list_tables.html', {'tables': user_tables})


def view_table(request, table_name):
    if table_name == 'favicon.ico':
        return HttpResponseNotFound()
    """Вывод данных из выбранной таблицы с пагинацией и названиями столбцов."""
    with connection.cursor() as cursor:
        # Получаем данные из выбранной таблицы
        cursor.execute(f"SELECT * FROM `{table_name}`;")
        rows = cursor.fetchall()

        # Получаем названия колонок (первый элемент из cursor.description)
        column_names = [desc[0] for desc in cursor.description]

    # Пагинация: 6 записей на страницу
    paginator = Paginator(rows, 6)
    page_number = request.GET.get("page")
    page_obj = paginator.get_page(page_number)

    return render(
        request,
        "db_app/view_table.html",
        {
            "table_name": table_name,
            "columns": column_names,  # Передаем названия колонок в шаблон
            "page_obj": page_obj,  # Объект пагинации
        },
    )


def get_model_by_name(table_name):
    # Используем Python reflection, чтобы найти модель по имени
    model_name = ''.join(tmp.capitalize() for tmp in table_name.split('_'))
    try:
        model = globals()[model_name]  # Получаем модель по имени
        return model
    except KeyError:
        raise Http404("Модель не найдена для таблицы: " + table_name, 'model_name:', model_name)


@login_required
def edit_record(request, table_name, key):
    # Получаем модель по имени таблицы
    model = get_model_by_name(table_name)

    print('afasdf', model)
    record = get_object_or_404(model, pk=key)


    # Создаем форму для этой модели
    form_class = modelform_factory(model, exclude=[model._meta.pk.name])
    form = form_class(instance=record)

    if request.method == 'POST':

        form = form_class(request.POST, request.FILES, instance=record)  # Обрабатываем файлы с request.FILES
        
        if form.is_valid():
            form.save()   
            return redirect('db_app:view_table', table_name=table_name)
    
    context = {
        'form': form,
        'table_name': table_name,
        'record': record,
    }
    return render(request, 'db_app/edit_record.html', context)

@login_required
def delete_record(request, table_name, key):
    # Получаем модель по имени таблицы
    model = get_model_by_name(table_name)

    # Определяем запись
    record = model.objects.filter(pk=key).first()

    if not record:
        raise Http404("Запись не найдена")

    # Удаляем запись
    if request.method == 'POST':
        record.delete()
        return redirect('db_app:view_table', table_name=table_name)

    # Преобразуем запись в словарь
    record_dict = model_to_dict(record)

    # Передаём запись в шаблон для отображения
    return render(request, 'db_app/confirm_delete.html', {
        'record': record_dict,  # Передаем словарь напрямую
        'table_name': table_name
    })


@login_required
def add_record(request, table_name):
    model = get_model_by_name(table_name)
    if table_name == 'bookings':
        form_class = modelform_factory(
            model,
            exclude=['id'],
            widgets={
                'check_in_date': forms.DateInput(attrs={'type': 'date'}),
                'check_out_date': forms.DateInput(attrs={'type': 'date'}),
            }
        )
    else:
        form_class = modelform_factory(model, exclude=['id'])
    form = form_class()

    if request.method == 'POST':
        form = form_class(request.POST)
        if form.is_valid():
            form.save()
            return redirect('db_app:view_table', table_name=table_name)

    context = {'form': form, 'table_name': table_name}
    return render(request, 'db_app/add_record.html', context)


def count_bookings(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT CountBookings();")
        bookings_count = cursor.fetchone()[0]

    return render(request, 'db_app/count_bookings.html', {'bookings_count': bookings_count})


def view_bookings(request):
    # Получаем GET параметры
    date_in_min = request.GET.get('date_in_min')
    date_in_max = request.GET.get('date_in_max')
    date_out_min = request.GET.get('date_out_min')
    date_out_max = request.GET.get('date_out_max')

    # Начальный QuerySet
    bookings = Bookings.objects.all()

    # Применяем фильтры
    if date_in_min:
        bookings = bookings.filter(check_in_date__gte=date_in_min)
    if date_in_max:
        bookings = bookings.filter(check_in_date__lte=date_in_max)
    if date_out_min:
        bookings = bookings.filter(check_out_date__gte=date_out_min)
    if date_out_max:
        bookings = bookings.filter(check_out_date__lte=date_out_max)

    # Добавляем пагинацию
    paginator = Paginator(bookings, 6)  # 6 записей на странице
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)

    columns = [
        'ID', 'Пользователь', 'Номер', 'Дата заезда', 'Дата выезда', 'Общая стоимость', 'Статус'
    ]
    context = {
        'table_name': 'bookings',
        'columns': columns,
        'page_obj': page_obj,
    }
    return render(request, 'db_app/view_table.html', context)


class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]

class UserView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)

def guest_view(request):
    # Показываем только свободные на сегодня номера
    today = date.today()
    from .models import Rooms, Bookings
    booked_rooms = Bookings.objects.filter(
        check_in_date__lte=today,
        check_out_date__gte=today
    ).values_list('room_id', flat=True)
    rooms = Rooms.objects.exclude(room_id__in=booked_rooms)
    return render(request, 'db_app/guest_rooms.html', {'rooms': rooms})

def login_page(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('db_app:list_tables')
        else:
            messages.error(request, 'Неверный логин или пароль')
    return render(request, 'db_app/auth.html', {'title': 'Вход'})

def register_page(request):
    return render(request, 'db_app/auth.html', {'title': 'Регистрация'})

def guest_room_detail(request, room_id):
    room = get_object_or_404(Rooms, room_id=room_id)
    images = RoomImages.objects.filter(room_id=room_id)
    if not images.exists():
        images = None  # Если изображений нет, передаем None
    return render(request, 'db_app/guest_room_detail.html', {'room': room, 'images': images})

class BookingListView(ListView):
    model = Bookings
    template_name = 'db_app/booking_list.html'
    context_object_name = 'bookings'

    def get_queryset(self):
        return Bookings.objects.all().order_by('-created_at')  # Сортировка по дате создания

def guest_book_room(request, room_id):
    from .models import Rooms, Bookings, Users
    room = get_object_or_404(Rooms, room_id=room_id)
    if request.method == 'POST':
        form = GuestBookingForm(request.POST)
        if form.is_valid():
            # Создаём уникального гостя
            unique_username = f"guest_{uuid.uuid4().hex[:8]}"
            guest_user = Users.objects.create(
                username=unique_username,
                password_hash='',
                email=f'{unique_username}@example.com',
                full_name=f"{form.cleaned_data['first_name']} {form.cleaned_data['last_name']}"
            )
            Bookings.objects.create(
                user=guest_user,
                room=room,
                check_in_date=form.cleaned_data['check_in_date'],
                check_out_date=form.cleaned_data['check_out_date'],
                total_price=room.price_per_night,
                status="Гостевое бронирование"
            )
            return redirect('db_app:guest_booking_success', room_id=room.room_id)
    else:
        form = GuestBookingForm()
    return render(request, 'db_app/guest_book_room.html', {'room': room, 'form': form})

def guest_booking_success(request, room_id):
    from .models import Rooms
    room = get_object_or_404(Rooms, room_id=room_id)
    return render(request, 'db_app/guest_booking_success.html', {'room': room})

class FreeRoomsAPIView(APIView):
    authentication_classes = []
    permission_classes = [AllowAny]
    def get(self, request):
        from .models import Rooms, Bookings
        from datetime import date
        check_in = request.GET.get('check_in')
        check_out = request.GET.get('check_out')
        qs = Rooms.objects.all()
        if check_in and check_out:
            booked_rooms = Bookings.objects.filter(
                check_in_date__lt=check_out,
                check_out_date__gt=check_in,
                status='active'
            ).values_list('room_id', flat=True)
            qs = qs.exclude(room_id__in=booked_rooms)
        else:
            today = date.today()
            booked_rooms = Bookings.objects.filter(
                check_in_date__lte=today,
                check_out_date__gte=today
            ).values_list('room_id', flat=True)
            qs = qs.exclude(room_id__in=booked_rooms)
        serializer = RoomSerializer(qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class UsersRegisterAPIView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = UsersRegisterSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"success": True, "user": serializer.data}, status=201)
        return Response(serializer.errors, status=400)

@method_decorator(csrf_exempt, name='dispatch')
class CustomTokenObtainPairView(APIView):
    @csrf_exempt
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        from .models import Users
        from rest_framework_simplejwt.tokens import RefreshToken
        try:
            user = Users.objects.get(email=email)
        except Users.DoesNotExist:
            return Response({'error': 'Пользователь не найден'}, status=404)
        if user.password_hash != password:
            return Response({'error': 'Неверный пароль'}, status=400)
        # Формируем токен вручную (НЕ используем for_user!)
        refresh = RefreshToken()
        refresh['user_id'] = user.user_id
        refresh['email'] = user.email  # Убедимся, что email есть в токене
        refresh['username'] = user.username
        refresh['full_name'] = user.full_name
        refresh['phone_number'] = user.phone_number
        access = refresh.access_token
        access['email'] = user.email  # Добавляем email и в access токен
        return Response({
            'refresh': str(refresh),
            'access': str(access),
            'user': {
                'user_id': user.user_id,
                'email': user.email,
                'username': user.username,
                'full_name': user.full_name,
                'phone_number': user.phone_number,
            }
        })

@method_decorator(csrf_exempt, name='dispatch')
class UsersProfileUpdateView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def put(self, request):
        from .models import Users
        from .serializers import UsersProfileUpdateSerializer
        
        try:
            user = Users.objects.get(email=request.user.email)
        except Users.DoesNotExist:
            return Response({'error': 'Пользователь не найден'}, status=404)
            
        serializer = UsersProfileUpdateSerializer(user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)

class UserBookingsAPIView(APIView):
    authentication_classes = []
    permission_classes = [AllowAny]
    def get(self, request):
        from .models import Bookings, Users
        email = request.query_params.get('email') or request.data.get('email')
        if not email:
            return Response([], status=200)
        try:
            db_user = Users.objects.get(email=email)
        except Users.DoesNotExist:
            return Response([], status=200)
        bookings = Bookings.objects.filter(user=db_user).select_related('room')
        serializer = BookingSerializer(bookings, many=True)
        return Response(serializer.data)

class BookingCreateAPIView(APIView):
    authentication_classes = []
    permission_classes = [AllowAny]

    def post(self, request):
        from .models import Bookings, Users, Rooms
        from rest_framework_simplejwt.authentication import JWTAuthentication
        from rest_framework_simplejwt.tokens import UntypedToken
        from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
        
        # Получаем токен из заголовка
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer '):
            return Response({'error': 'Требуется токен авторизации'}, status=401)
        
        token = auth_header.split(' ')[1]
        try:
            # Декодируем токен
            untyped_token = UntypedToken(token)
            email = untyped_token.get('email')
            if not email:
                return Response({'error': 'Email не найден в токене'}, status=401)
        except (InvalidToken, TokenError) as e:
            return Response({'error': f'Неверный токен: {str(e)}'}, status=401)
        
        data = request.data
        room_id = data.get('room')
        check_in = data.get('check_in')
        check_out = data.get('check_out')
        
        if not (room_id and check_in and check_out):
            return Response({'error': 'Необходимы room, check_in, check_out'}, status=400)
        
        try:
            user = Users.objects.get(email=email)
        except Users.DoesNotExist:
            return Response({'error': 'Пользователь не найден'}, status=404)
        
        try:
            room = Rooms.objects.get(room_id=room_id)
        except Rooms.DoesNotExist:
            return Response({'error': 'Номер не найден'}, status=404)
        
        # Проверка занятости номера на эти даты
        overlapping = Bookings.objects.filter(
            room=room,
            check_in_date__lt=check_out,
            check_out_date__gt=check_in,
            status='active'
        ).exists()
        
        if overlapping:
            return Response({'error': 'Номер уже занят на выбранные даты'}, status=400)
        
        try:
            booking = Bookings.objects.create(
                user=user,
                room=room,
                check_in_date=check_in,
                check_out_date=check_out,
                total_price=room.price_per_night,
                status='active'
            )
            serializer = BookingSerializer(booking)
            return Response(serializer.data, status=201)
        except Exception as e:
            return Response({'error': f'Ошибка при создании бронирования: {str(e)}'}, status=400)

@method_decorator(csrf_exempt, name='dispatch')
class BookingDeleteAPIView(APIView):
    authentication_classes = []
    permission_classes = [AllowAny]

    def delete(self, request, booking_id):
        from .models import Bookings, Users
        from rest_framework_simplejwt.tokens import UntypedToken
        from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
        # Получаем токен из заголовка
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer '):
            return Response({'error': 'Требуется токен авторизации'}, status=401)
        token = auth_header.split(' ')[1]
        try:
            untyped_token = UntypedToken(token)
            email = untyped_token.get('email')
            if not email:
                return Response({'error': 'Email не найден в токене'}, status=401)
        except (InvalidToken, TokenError) as e:
            return Response({'error': f'Неверный токен: {str(e)}'}, status=401)
        try:
            booking = Bookings.objects.get(booking_id=booking_id)
            if booking.user.email != email:
                return Response({'error': 'У вас нет прав на отмену этого бронирования'}, status=403)
            booking.delete()
            return Response({'success': True}, status=status.HTTP_204_NO_CONTENT)
        except Bookings.DoesNotExist:
            return Response({'error': 'Бронирование не найдено'}, status=404)
        except Exception as e:
            return Response({'error': f'Ошибка при отмене бронирования: {str(e)}'}, status=400)

class CustomTokenRefreshView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        refresh_token = request.data.get('refresh')
        if not refresh_token:
            return Response({'error': 'Refresh token is required'}, status=400)
        try:
            from rest_framework_simplejwt.tokens import RefreshToken
            refresh = RefreshToken(refresh_token)
            email = refresh.get('email')
            if not email:
                return Response({'error': 'Invalid refresh token'}, status=401)
            # Получаем пользователя
            from .models import Users
            user = Users.objects.get(email=email)
            # Только access!
            access = refresh.access_token
            access['email'] = user.email
            return Response({
                'access': str(access)
            })
        except (TokenError, Users.DoesNotExist):
            return Response({'error': 'Invalid refresh token'}, status=401)
        except Exception as e:
            return Response({'error': str(e)}, status=400)

@method_decorator(csrf_exempt, name='dispatch')
class BookingCancelAPIView(APIView):
    authentication_classes = []
    permission_classes = [AllowAny]

    def post(self, request):
        from .models import Bookings
        from rest_framework_simplejwt.tokens import UntypedToken
        from rest_framework_simplejwt.exceptions import InvalidToken, TokenError

        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer '):
            return Response({'error': 'Требуется токен авторизации'}, status=401)
        token = auth_header.split(' ')[1]
        try:
            untyped_token = UntypedToken(token)
            email = untyped_token.get('email')
            if not email:
                return Response({'error': 'Email не найден в токене'}, status=401)
        except (InvalidToken, TokenError) as e:
            return Response({'error': f'Неверный токен: {str(e)}'}, status=401)

        booking_id = request.data.get('booking_id')
        if not booking_id:
            return Response({'error': 'Не передан booking_id'}, status=400)
        try:
            booking = Bookings.objects.get(booking_id=booking_id)
            if booking.user.email != email:
                return Response({'error': 'У вас нет прав на отмену этого бронирования'}, status=403)
            booking.delete()
            return Response({'success': True}, status=status.HTTP_204_NO_CONTENT)
        except Bookings.DoesNotExist:
            return Response({'error': 'Бронирование не найдено'}, status=404)
        except Exception as e:
            return Response({'error': f'Ошибка при отмене бронирования: {str(e)}'}, status=400)

def custom_logout(request):
    logout(request)
    return redirect('db_app:login_page')
