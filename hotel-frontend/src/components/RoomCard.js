import React, { useState } from 'react';
import {
    Card,
    CardContent,
    Typography,
    Button,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    Box,
    Stack,
    Chip,
    Divider,
    Alert,
    Snackbar
} from '@mui/material';
import { motion } from 'framer-motion';
import BedIcon from '@mui/icons-material/Bed';
import AttachMoneyIcon from '@mui/icons-material/AttachMoney';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';
import PhotoCameraBackIcon from '@mui/icons-material/PhotoCameraBack';

const DEFAULT_IMAGE = 'https://via.placeholder.com/340x180?text=Нет+фото';
const API_BASE = 'http://localhost:8086';

const RoomCard = ({ room, onBooked }) => {
    const [open, setOpen] = useState(false);
    const [startDate, setStartDate] = useState(null);
    const [endDate, setEndDate] = useState(null);
    const [error, setError] = useState(null);
    const { user } = useAuth();

    const handleBook = async () => {
        if (!user) {
            // Перенаправить на страницу входа
            return;
        }
        try {
            const token = localStorage.getItem('accessToken');
            console.log('Token:', token);

            if (!token) {
                console.error('No token found');
                return;
            }

            const bookingData = {
                room: room.room_id,
                check_in: startDate && startDate.toISOString().slice(0, 10),
                check_out: endDate && endDate.toISOString().slice(0, 10),
                email: user.email,
            };

            console.log('Booking data:', bookingData);

            const response = await axios.post('http://localhost:8086/api/bookings/',
                bookingData,
                {
                    headers: {
                        'Authorization': `Bearer ${token}`,
                        'Content-Type': 'application/json'
                    }
                }
            );

            console.log('Booking response:', response.data);
            setOpen(false);
            if (onBooked) onBooked(
                startDate && startDate.toISOString().slice(0, 10),
                endDate && endDate.toISOString().slice(0, 10)
            );
            setError({ type: 'success', message: 'Номер успешно забронирован!' });
        } catch (error) {
            console.error('Booking error:', error.response?.data || error.message);
            setError({
                type: 'error',
                message: error.response?.data?.error || 'Произошла ошибка при бронировании'
            });
        }
    };

    const handleCloseError = () => {
        setError(null);
    };

    return (
        <>
            <Card
                component={motion.div}
                whileHover={{ scale: 1.03, boxShadow: '0 8px 32px rgba(33, 150, 243, 0.15)' }}
                sx={{
                    width: 340,
                    minHeight: 340,
                    height: '100%',
                    m: 'auto',
                    borderRadius: 4,
                    boxShadow: 3,
                    display: 'flex',
                    flexDirection: 'column',
                    transition: 'box-shadow 0.3s',
                    background: 'linear-gradient(135deg, #e3f2fd 0%, #fff 100%)',
                }}
            >
                {room.image_url ? (
                    <Box sx={{ width: '100%', height: 180, overflow: 'hidden', borderTopLeftRadius: 16, borderTopRightRadius: 16 }}>
                        <img
                            src={room.image_url.startsWith('http') ? room.image_url + '?v=' + Date.now() : API_BASE + room.image_url + '?v=' + Date.now()}
                            alt={room.room_number}
                            style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
                        />
                    </Box>
                ) : (
                    <Box sx={{ width: '100%', height: 180, display: 'flex', alignItems: 'center', justifyContent: 'center', bgcolor: '#eee', color: '#888', borderTopLeftRadius: 16, borderTopRightRadius: 16, flexDirection: 'column' }}>
                        <PhotoCameraBackIcon sx={{ fontSize: 48, mb: 1 }} />
                        <Typography variant="subtitle2" color="text.secondary">
                            Извините, фотограф спился
                        </Typography>
                    </Box>
                )}
                <CardContent sx={{ flexGrow: 1 }}>
                    <Stack direction="row" alignItems="center" spacing={1} mb={1}>
                        <BedIcon color="primary" />
                        <Typography variant="h6" fontWeight={700} color="primary.main">
                            {room.room_number} — {room.room_type}
                        </Typography>
                        <Chip label={`ID: ${room.room_id}`} size="small" sx={{ ml: 'auto', bgcolor: '#e3f2fd' }} />
                    </Stack>
                    <Typography variant="body2" color="text.secondary" mb={2}>
                        {room.description}
                    </Typography>
                    <Divider sx={{ my: 1 }} />
                    <Stack direction="row" alignItems="center" spacing={1} mb={1}>
                        <AttachMoneyIcon color="success" />
                        <Typography variant="h6" color="success.main" fontWeight={700}>
                            {room.price_per_night} ₽/ночь
                        </Typography>
                    </Stack>
                    <Typography variant="body2" color="text.secondary">
                        Вместимость: <b>{room.capacity}</b> чел.
                    </Typography>
                </CardContent>
                <Button
                    variant="contained"
                    color="primary"
                    onClick={() => setOpen(true)}
                    sx={{ m: 2, borderRadius: 2, fontWeight: 600, boxShadow: 2 }}
                >
                    Забронировать
                </Button>
            </Card>

            <Dialog open={open} onClose={() => setOpen(false)}>
                <DialogTitle>Бронирование номера</DialogTitle>
                <DialogContent>
                    <Typography variant="subtitle1" sx={{ mt: 2 }}>
                        Выберите даты заезда и выезда:
                    </Typography>
                    <Box sx={{ mt: 2, display: 'flex', gap: 2 }}>
                        <DatePicker
                            selected={startDate}
                            onChange={date => setStartDate(date)}
                            selectsStart
                            startDate={startDate}
                            endDate={endDate}
                            minDate={new Date()}
                            placeholderText="Дата заезда"
                            withPortal
                        />
                        <DatePicker
                            selected={endDate}
                            onChange={date => setEndDate(date)}
                            selectsEnd
                            startDate={startDate}
                            endDate={endDate}
                            minDate={startDate}
                            placeholderText="Дата выезда"
                            withPortal
                        />
                    </Box>
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setOpen(false)}>Отмена</Button>
                    <Button onClick={handleBook} variant="contained" color="primary">
                        Подтвердить
                    </Button>
                </DialogActions>
            </Dialog>

            <Snackbar
                open={!!error}
                autoHideDuration={6000}
                onClose={handleCloseError}
                anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
            >
                <Alert
                    onClose={handleCloseError}
                    severity={error?.type || 'error'}
                    sx={{ width: '100%' }}
                >
                    {error?.message}
                </Alert>
            </Snackbar>
        </>
    );
};

export default RoomCard; 