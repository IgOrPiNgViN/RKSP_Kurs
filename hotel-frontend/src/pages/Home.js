import React, { useState, useEffect } from 'react';
import {
    Container,
    Grid,
    Typography,
    Box,
    CircularProgress,
    Alert,
    TextField,
    Slider,
    Button,
    Stack
} from '@mui/material';
import RoomCard from '../components/RoomCard';
import axios from 'axios';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

const PAGE_SIZE = 6;

const Home = () => {
    const [rooms, setRooms] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [search, setSearch] = useState('');
    const [priceRange, setPriceRange] = useState([0, 10000]);
    const [sortOrder, setSortOrder] = useState('asc');
    const [minPrice, setMinPrice] = useState(0);
    const [maxPrice, setMaxPrice] = useState(10000);
    const [selectedCheckIn, setSelectedCheckIn] = useState(null);
    const [selectedCheckOut, setSelectedCheckOut] = useState(null);
    const [currentPage, setCurrentPage] = useState(1);

    const fetchRooms = async (checkIn, checkOut) => {
        try {
            let url = 'http://localhost:8000/api/rooms/';
            if (checkIn && checkOut) {
                url += `?check_in=${checkIn}&check_out=${checkOut}`;
            }
            const response = await axios.get(url);
            setRooms(response.data);
            setLoading(false);
            // Устанавливаем минимальную и максимальную цену
            if (response.data.length > 0) {
                const prices = response.data.map(r => parseFloat(r.price_per_night || r.price));
                setMinPrice(Math.min(...prices));
                setMaxPrice(Math.max(...prices));
                setPriceRange([Math.min(...prices), Math.max(...prices)]);
            }
            if (checkIn && checkOut) {
                setSelectedCheckIn(checkIn);
                setSelectedCheckOut(checkOut);
            }
        } catch (err) {
            setError('Ошибка при загрузке номеров');
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchRooms();
    }, []);

    const handleSearch = (e) => setSearch(e.target.value);
    const handlePriceChange = (e, newValue) => setPriceRange(newValue);
    const handleSort = (order) => setSortOrder(order);

    const handleDateChange = (date) => {
        setSelectedCheckIn(date);
        if (date) {
            // check_out = check_in + 1 день (минимум)
            const nextDay = new Date(date);
            nextDay.setDate(date.getDate() + 1);
            setSelectedCheckOut(nextDay);
            fetchRooms(date.toISOString().slice(0, 10), nextDay.toISOString().slice(0, 10));
        } else {
            fetchRooms();
        }
    };

    // Фильтрация и сортировка
    const filteredRooms = rooms
        .filter(room => {
            const name = room.name || room.room_number || '';
            const description = room.description || '';
            const price = parseFloat(room.price_per_night || room.price);
            return (
                (name.toLowerCase().includes(search.toLowerCase()) ||
                    description.toLowerCase().includes(search.toLowerCase())) &&
                price >= priceRange[0] && price <= priceRange[1]
            );
        })
        .sort((a, b) => {
            const priceA = parseFloat(a.price_per_night || a.price);
            const priceB = parseFloat(b.price_per_night || b.price);
            return sortOrder === 'asc' ? priceA - priceB : priceB - priceA;
        });

    // Пагинация
    const totalPages = Math.ceil(filteredRooms.length / PAGE_SIZE);
    const paginatedRooms = filteredRooms.slice((currentPage - 1) * PAGE_SIZE, currentPage * PAGE_SIZE);

    useEffect(() => {
        setCurrentPage(1); // Сброс на первую страницу при изменении фильтров
    }, [search, priceRange, sortOrder, selectedCheckIn, selectedCheckOut]);

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="80vh">
                <CircularProgress />
            </Box>
        );
    }

    if (error) {
        return (
            <Container>
                <Alert severity="error" sx={{ mt: 4 }}>
                    {error}
                </Alert>
            </Container>
        );
    }

    return (
        <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
            <Typography variant="h3" component="h1" gutterBottom align="center">
                Наши номера
            </Typography>
            <Typography variant="subtitle1" color="text.secondary" align="center" paragraph>
                Выберите идеальный номер для вашего отдыха
            </Typography>
            <Box sx={{ mb: 3 }}>
                <DatePicker
                    selected={selectedCheckIn}
                    onChange={handleDateChange}
                    minDate={new Date()}
                    placeholderText="Выберите дату заезда"
                    dateFormat="yyyy-MM-dd"
                    isClearable
                    withPortal
                    customInput={<TextField label="Дата заезда" variant="outlined" fullWidth sx={{ mb: 2 }} />}
                />
                <TextField
                    label="Поиск по названию или описанию"
                    variant="outlined"
                    fullWidth
                    value={search}
                    onChange={handleSearch}
                    sx={{ mb: 2 }}
                />
                <Typography gutterBottom>Фильтр по цене (₽):</Typography>
                <Slider
                    value={priceRange}
                    onChange={handlePriceChange}
                    valueLabelDisplay="auto"
                    min={minPrice}
                    max={maxPrice}
                    sx={{ width: 300, mb: 2 }}
                />
                <Stack direction="row" spacing={2} sx={{ mb: 2 }}>
                    <Button
                        variant={sortOrder === 'asc' ? 'contained' : 'outlined'}
                        onClick={() => handleSort('asc')}
                    >
                        Цена ↑
                    </Button>
                    <Button
                        variant={sortOrder === 'desc' ? 'contained' : 'outlined'}
                        onClick={() => handleSort('desc')}
                    >
                        Цена ↓
                    </Button>
                </Stack>
            </Box>
            <Grid
                container
                spacing={4}
                justifyContent="center"
                alignItems="stretch"
                wrap="wrap"
            >
                {paginatedRooms.map((room) => (
                    <Grid
                        item
                        key={room.room_id || room.id}
                        xs={12}
                        sm={6}
                        md={4}
                        sx={{ display: 'flex', justifyContent: 'center', alignItems: 'stretch' }}
                    >
                        <RoomCard room={room} onBooked={fetchRooms} selectedCheckIn={selectedCheckIn} selectedCheckOut={selectedCheckOut} />
                    </Grid>
                ))}
            </Grid>
            {/* Пагинация */}
            {totalPages > 1 && (
                <Box display="flex" justifyContent="center" mt={4} gap={1}>
                    {Array.from({ length: totalPages }, (_, i) => (
                        <Button
                            key={i + 1}
                            variant={currentPage === i + 1 ? 'contained' : 'outlined'}
                            onClick={() => setCurrentPage(i + 1)}
                        >
                            {i + 1}
                        </Button>
                    ))}
                </Box>
            )}
        </Container>
    );
};

export default Home; 