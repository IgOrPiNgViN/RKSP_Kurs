from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Rooms, Users, Bookings

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ("id", "username", "email", "first_name", "last_name")

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)
    first_name = serializers.CharField(required=False, allow_blank=True)
    last_name = serializers.CharField(required=False, allow_blank=True)

    class Meta:
        model = User
        fields = ("username", "email", "password", "password2", "first_name", "last_name")

    def validate(self, data):
        if data["password"] != data["password2"]:
            raise serializers.ValidationError("Пароли не совпадают")
        return data

    def create(self, validated_data):
        validated_data.pop("password2")
        user = User.objects.create_user(**validated_data)
        return user 

class RoomSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = Rooms
        fields = '__all__'

    def get_image_url(self, obj):
        from .models import RoomImages
        image = RoomImages.objects.filter(room=obj).first()
        if image and image.image_path:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(image.image_path.url)
            return image.image_path.url
        return None

class UsersRegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)
    first_name = serializers.CharField(write_only=True, required=False, allow_blank=True)
    last_name = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = Users
        fields = ("username", "email", "password", "password2", "first_name", "last_name", "full_name", "phone_number")

    def validate(self, data):
        if data["password"] != data["password2"]:
            raise serializers.ValidationError("Пароли не совпадают")
        if Users.objects.filter(email=data["email"]).exists():
            raise serializers.ValidationError("Пользователь с таким email уже существует")
        return data

    def create(self, validated_data):
        validated_data.pop("password2")
        password = validated_data.pop("password")
        first_name = validated_data.pop("first_name", "")
        last_name = validated_data.pop("last_name", "")
        full_name = f"{first_name} {last_name}".strip()
        validated_data["full_name"] = full_name
        user = Users.objects.create(password_hash=password, **validated_data)
        return user

class UsersProfileUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Users
        fields = ('email', 'full_name', 'phone_number')

    def validate_email(self, value):
        user_id = self.instance.user_id if self.instance else None
        if Users.objects.exclude(user_id=user_id).filter(email=value).exists():
            raise serializers.ValidationError("Пользователь с таким email уже существует")
        return value

class BookingRoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Rooms
        fields = ('room_id', 'room_number', 'room_type', 'price_per_night', 'description', 'capacity')

class BookingSerializer(serializers.ModelSerializer):
    room = BookingRoomSerializer(read_only=True)
    class Meta:
        model = Bookings
        fields = ('booking_id', 'room', 'check_in_date', 'check_out_date', 'total_price', 'status') 