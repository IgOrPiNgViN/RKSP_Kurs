from decimal import Decimal
import pytest
from hypothesis import given, strategies as st
from hypothesis.extra.django import from_model, TestCase
from django.core.exceptions import ValidationError
from ..models import Room, RoomCategory

class TestRoomFuzzing(TestCase):
    @given(
        number=st.text(alphabet=st.characters(max_codepoint=127), min_size=1, max_size=10),
        price=st.decimals(min_value=0, max_value=999999.99, places=2)
    )
    def test_room_creation(self, number, price):
        # Create a test category
        category = RoomCategory.objects.create(
            name="Test Category",
            description="Test Description"
        )
        
        # Try to create a room with fuzzed data
        try:
            room = Room.objects.create(
                number=number,
                category=category,
                price=price
            )
            
            # Verify the room was created correctly
            assert room.number == number
            assert room.price == Decimal(str(price))
            assert room.category == category
            assert room.is_active is True
            
        except Exception as e:
            # If creation fails, it should be due to validation
            # and not due to database encoding issues
            assert isinstance(e, (ValueError, TypeError, ValidationError))

    @given(
        price=st.decimals(min_value=-1000, max_value=1000, places=2)
    )
    def test_room_price_validation(self, price):
        category = RoomCategory.objects.create(
            name="Test Category",
            description="Test Description"
        )
        
        # Create a room instance but don't save it yet
        room = Room(
            number="101",
            category=category,
            price=price
        )
        
        # Test price validation
        if price < 0:
            with pytest.raises(ValidationError):
                room.full_clean()  # This will run model validation
        else:
            room.full_clean()  # Should not raise for positive prices
            room.save()
            assert room.price == Decimal(str(price))

    @given(
        number=st.text(alphabet=st.characters(max_codepoint=127), min_size=0, max_size=20)
    )
    def test_room_number_validation(self, number):
        category = RoomCategory.objects.create(
            name="Test Category",
            description="Test Description"
        )
        
        # Create a room instance but don't save it yet
        room = Room(
            number=number,
            category=category,
            price=100.00
        )
        
        # Test room number validation
        if not number or len(number) > 10:
            with pytest.raises(ValidationError):
                room.full_clean()
        else:
            room.full_clean()
            room.save()
            assert room.number == number 