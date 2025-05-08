from django.urls import path, reverse_lazy
from db_app import views
from django.contrib.auth import views as auth_views
from django.conf import settings
from django.conf.urls.static import static
from rest_framework_simplejwt.views import TokenObtainPairView
from db_app.views import FreeRoomsAPIView, UsersRegisterAPIView, CustomTokenObtainPairView, CustomTokenRefreshView, UsersProfileUpdateView, UserBookingsAPIView, BookingCreateAPIView, BookingDeleteAPIView

app_name = 'db_app'

urlpatterns = [
    # Гостевая страница:
    path('guest/', views.guest_view, name='guest_rooms'),
    path('login/', views.login_page, name='login_page'),
    path('register/', views.register_page, name='register_page'),
    path('logout/', views.custom_logout, name='logout'),
    # JWT и регистрация:
    path('api/register/', views.RegisterView.as_view(), name='api_register'),
    path('api/token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', CustomTokenRefreshView.as_view(), name='token_refresh'),
    path('api/user/', views.UserView.as_view(), name='api_user'),
    path('api/rooms/', FreeRoomsAPIView.as_view(), name='api_rooms'),
    path('api/user/register/', UsersRegisterAPIView.as_view(), name='api_user_register'),
    path('api/user/profile/', UsersProfileUpdateView.as_view(), name='api_user_profile'),
    path('api/bookings/user/', UserBookingsAPIView.as_view(), name='api_user_bookings'),
    path('api/bookings/', BookingCreateAPIView.as_view(), name='api_create_booking'),
    path('api/bookings/<int:booking_id>/', views.BookingDeleteAPIView.as_view(), name='api_delete_booking'),
    path('api/bookings/cancel/', views.BookingCancelAPIView.as_view(), name='api_cancel_booking'),
    path('', views.list_tables, name='list_tables'),
    path('count_bookings/', views.count_bookings, name='count_bookings'),
    path('bookings/', views.view_bookings, name='view_bookings'),
    path('<str:table_name>/', views.view_table, name='view_table'),
    path('<str:table_name>/edit/<int:key>/', views.edit_record, name='edit_record'),
    path('<str:table_name>/delete/<int:key>/', views.delete_record, name='delete_record'),
    path('add/<str:table_name>', views.add_record, name='add_record'),
    path('guest/room/<int:room_id>/', views.guest_room_detail, name='guest_room_detail'),
    path('guest/book/<int:room_id>/', views.guest_book_room, name='guest_book_room'),
    path('guest/success/<int:room_id>/', views.guest_booking_success, name='guest_booking_success'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)