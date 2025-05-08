import React, { useState, useEffect } from 'react';
import {
    Container,
    Paper,
    Typography,
    Box,
    Grid,
    Card,
    CardContent,
    Button,
    CircularProgress,
    Alert,
    TextField,
    Snackbar
} from '@mui/material';
import { useAuth } from '../contexts/AuthContext';
import axios from 'axios';

const Profile = () => {
    const { user, setUser, refreshAccessToken } = useAuth();
    const [bookings, setBookings] = useState([]);
    const [loading, setLoading] = useState(true);
    const [profileError, setProfileError] = useState(null);
    const [bookingsError, setBookingsError] = useState(null);
    const [isEditing, setIsEditing] = useState(false);
    const [notification, setNotification] = useState(null);
    const [formData, setFormData] = useState({
        full_name: '',
        email: '',
    });

    useEffect(() => {
        if (user) {
            setFormData({
                full_name: user.full_name || '',
                email: user.email || '',
            });
        }
    }, [user]);

    useEffect(() => {
        const fetchBookings = async () => {
            try {
                const response = await axios.get('http://localhost:8000/api/bookings/user/', {
                    params: { email: user?.email },
                });
                setBookings(response.data);
                setLoading(false);
            } catch (err) {
                setBookingsError('Ошибка при загрузке бронирований');
                setLoading(false);
            }
        };
        if (user) {
            fetchBookings();
        }
    }, [user]);

    const handleCancelBooking = async (bookingId) => {
        try {
            // const token = await refreshAccessToken();
            const token = localStorage.getItem('accessToken');
            if (!token) {
                setNotification({ type: 'error', message: 'Требуется авторизация' });
                return;
            }
            await axios.post('http://localhost:8000/api/bookings/cancel/', {
                booking_id: bookingId
            }, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });
            setBookings(bookings.filter(booking => booking.booking_id !== bookingId));
            setNotification({ type: 'success', message: 'Бронирование успешно отменено' });
        } catch (err) {
            setNotification({
                type: 'error',
                message: err.response?.data?.error || 'Ошибка при отмене бронирования'
            });
        }
    };

    const handleCloseNotification = () => {
        setNotification(null);
    };

    const handleEdit = () => {
        setIsEditing(true);
    };

    const handleCancel = () => {
        setIsEditing(false);
        setFormData({
            full_name: user.full_name || '',
            email: user.email || '',
        });
    };

    const fetchUserProfile = async () => {
        try {
            const token = await refreshAccessToken();
            if (!token) return;
            const response = await axios.get('http://localhost:8000/api/user/profile/');
            setUser(response.data);
        } catch (error) {
            console.error('Error fetching profile:', error);
        }
    };

    const handleSave = async () => {
        try {
            const token = await refreshAccessToken();
            if (!token) {
                setProfileError('Требуется авторизация');
                return;
            }
            const dataToSend = {
                full_name: formData.full_name,
            };
            await axios.put(
                `http://localhost:8000/api/user/profile/`,
                dataToSend
            );
            await fetchUserProfile();
            setIsEditing(false);
            setProfileError(null);
            setNotification({ type: 'success', message: 'Профиль успешно обновлён' });
        } catch (err) {
            setProfileError('Ошибка при сохранении данных');
        }
    };

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="80vh">
                <CircularProgress />
            </Box>
        );
    }

    return (
        <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
            <Paper sx={{ p: 3, mb: 3 }}>
                <Typography variant="h5" gutterBottom>
                    Профиль пользователя
                </Typography>
                <Card>
                    <CardContent>
                        <Typography variant="subtitle1"><b>ФИО:</b> {formData.full_name || '-'}</Typography>
                        <Typography variant="subtitle1"><b>Email:</b> {formData.email || '-'}</Typography>
                    </CardContent>
                </Card>
            </Paper>
            <Grid container spacing={4}>
                <Grid item xs={12} md={8}>
                    <Typography variant="h5" gutterBottom>
                        Мои бронирования
                    </Typography>
                    {bookingsError && (
                        <Alert severity="error" sx={{ mb: 2 }}>
                            {bookingsError}
                        </Alert>
                    )}
                    {bookings.length === 0 ? (
                        <Typography variant="body1" color="text.secondary">
                            У вас пока нет бронирований
                        </Typography>
                    ) : (
                        <Grid container spacing={2}>
                            {bookings.map((booking) => (
                                <Grid item xs={12} key={booking.booking_id}>
                                    <Card>
                                        <CardContent>
                                            <Typography variant="h6">
                                                Номер: {booking.room?.room_number} — {booking.room?.room_type}
                                            </Typography>
                                            <Typography variant="body2" color="text.secondary">
                                                Заезд: {booking.check_in_date ? new Date(booking.check_in_date).toLocaleDateString() : ''}
                                            </Typography>
                                            <Typography variant="body2" color="text.secondary">
                                                Выезд: {booking.check_out_date ? new Date(booking.check_out_date).toLocaleDateString() : ''}
                                            </Typography>
                                            <Typography variant="body2" color="text.secondary">
                                                Статус: {booking.status}
                                            </Typography>
                                            {booking.status === 'active' && (
                                                <Button
                                                    variant="outlined"
                                                    color="error"
                                                    size="small"
                                                    onClick={() => handleCancelBooking(booking.booking_id)}
                                                    sx={{ mt: 1 }}
                                                >
                                                    Отменить бронирование
                                                </Button>
                                            )}
                                        </CardContent>
                                    </Card>
                                </Grid>
                            ))}
                        </Grid>
                    )}
                </Grid>
            </Grid>
            <Snackbar
                open={!!notification}
                autoHideDuration={6000}
                onClose={handleCloseNotification}
                anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
            >
                <Alert
                    onClose={handleCloseNotification}
                    severity={notification?.type || 'success'}
                    sx={{ width: '100%' }}
                >
                    {notification?.message}
                </Alert>
            </Snackbar>
        </Container>
    );
};

export default Profile; 