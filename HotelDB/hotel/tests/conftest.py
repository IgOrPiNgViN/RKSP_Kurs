import os
import django
import pytest
from django.conf import settings
import warnings

# Suppress deprecation warnings
warnings.filterwarnings('ignore', category=DeprecationWarning)
warnings.filterwarnings('ignore', category=UserWarning)

# Устанавливаем переменную окружения для настроек Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'HotelDB.settings')

# Инициализируем Django
django.setup()

@pytest.fixture(autouse=True)
def django_db_setup():
    settings.DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': 'test_db',
            'USER': 'hotel_user',
            'PASSWORD': '1234',
            'HOST': 'localhost',
            'PORT': '3306',
        }
    } 