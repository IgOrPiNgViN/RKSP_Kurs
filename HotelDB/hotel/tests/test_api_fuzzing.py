import pytest
from hypothesis import given, strategies as st, settings
from rest_framework.test import APIClient
from rest_framework import status
from unittest.mock import patch, MagicMock
from rest_framework.response import Response
from typing import cast
import json

# Настройки hypothesis
settings.register_profile("dev", max_examples=3)
settings.load_profile("dev")

class TestRoomAPIFuzzing:
    def setup_method(self):
        self.client = APIClient()
        self.base_url = '/api/rooms/create/'  # Обновленный URL для создания комнат

    def print_test_result(self, test_name, data, response):
        """Вывод результатов теста в консоль"""
        print("\n" + "="*50)
        print(f"Тест: {test_name}")
        print(f"Входные данные: {json.dumps(data, indent=2, ensure_ascii=False)}")
        print(f"Статус код: {response.status_code}")
        print(f"Ответ: {json.dumps(response.data, indent=2, ensure_ascii=False) if hasattr(response, 'data') else 'Нет данных'}")
        print("="*50 + "\n")

    @settings(deadline=None)
    @given(
        room_number=st.integers(min_value=1, max_value=999),
        price=st.decimals(min_value=0, max_value=1000000, places=2),
        category=st.text(min_size=1, max_size=50)
    )
    def test_room_creation_fuzz(self, room_number, price, category):
        """Тестирование создания комнаты с случайными данными"""
        data = {
            'room_number': str(room_number),  # Преобразуем в строку, так как в модели это CharField
            'price_per_night': float(price),
            'room_type': category,
            'capacity': 2  # Добавляем обязательное поле
        }
        
        # Создаем мок для RoomImages
        mock_room_images = MagicMock()
        mock_room_images.filter.return_value.first.return_value = None
        
        # Создаем мок для сериализатора
        mock_serializer = MagicMock()
        mock_serializer.is_valid.return_value = True
        mock_serializer.save.return_value = type('Room', (), {'room_id': 1, **data})
        mock_serializer.data = data
        
        with patch('db_app.views.RoomSerializer', return_value=mock_serializer), \
             patch('db_app.models.RoomImages.objects', mock_room_images):
            response = cast(Response, self.client.post(self.base_url, data, format='json'))
            self.print_test_result("Создание комнаты", data, response)
            assert response.status_code == status.HTTP_201_CREATED

    @given(price=st.decimals(min_value=-1000000, max_value=1000000, places=2))
    def test_room_price_validation_fuzz(self, price):
        """Тестирование валидации цены комнаты"""
        data = {
            'room_number': '101',
            'price_per_night': float(price),
            'room_type': 'Standard',
            'capacity': 2
        }
        
        # Создаем мок для RoomImages
        mock_room_images = MagicMock()
        mock_room_images.filter.return_value.first.return_value = None
        
        # Создаем мок для сериализатора
        mock_serializer = MagicMock()
        mock_serializer.is_valid.return_value = price >= 0
        mock_serializer.errors = {'price_per_night': ['Price must be positive']} if price < 0 else {}
        mock_serializer.data = data if price >= 0 else {}
        
        with patch('db_app.views.RoomSerializer', return_value=mock_serializer), \
             patch('db_app.models.RoomImages.objects', mock_room_images):
            response = cast(Response, self.client.post(self.base_url, data, format='json'))
            self.print_test_result("Валидация цены", data, response)
            
            if price < 0:
                assert response.status_code == status.HTTP_400_BAD_REQUEST
            else:
                assert response.status_code == status.HTTP_201_CREATED

    @given(room_number=st.integers(min_value=-1000, max_value=1000))
    def test_room_number_validation_fuzz(self, room_number):
        """Тестирование валидации номера комнаты"""
        data = {
            'room_number': str(room_number),
            'price_per_night': 100.00,
            'room_type': 'Standard',
            'capacity': 2
        }
        
        # Создаем мок для RoomImages
        mock_room_images = MagicMock()
        mock_room_images.filter.return_value.first.return_value = None
        
        # Создаем мок для сериализатора
        mock_serializer = MagicMock()
        mock_serializer.is_valid.return_value = room_number > 0
        mock_serializer.errors = {'room_number': ['Room number must be positive']} if room_number <= 0 else {}
        mock_serializer.data = data if room_number > 0 else {}
        
        with patch('db_app.views.RoomSerializer', return_value=mock_serializer), \
             patch('db_app.models.RoomImages.objects', mock_room_images):
            response = cast(Response, self.client.post(self.base_url, data, format='json'))
            self.print_test_result("Валидация номера комнаты", data, response)
            
            if room_number <= 0:
                assert response.status_code == status.HTTP_400_BAD_REQUEST
            else:
                assert response.status_code == status.HTTP_201_CREATED 