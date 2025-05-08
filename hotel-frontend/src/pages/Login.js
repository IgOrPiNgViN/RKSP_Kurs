import React, { useState } from 'react';
import {
    Container,
    Paper,
    Typography,
    TextField,
    Button,
    Box,
    Alert,
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

const Login = () => {
    const [formData, setFormData] = useState({
        email: '',
        password: '',
    });
    const [error, setError] = useState('');
    const navigate = useNavigate();
    const { login } = useAuth();

    const handleChange = (e) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value,
        });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        try {
            await login(formData.email, formData.password);
            navigate('/');
        } catch (err) {
            setError(
                err.response?.data?.error || 'Ошибка входа. Проверьте email и пароль.'
            );
        }
    };

    return (
        <Container maxWidth="sm" sx={{ mt: 8 }}>
            <Paper elevation={3} sx={{ p: 4 }}>
                <Typography variant="h4" component="h1" gutterBottom align="center">
                    Вход в систему
                </Typography>
                {error && (
                    <Alert severity="error" sx={{ mb: 2 }}>
                        {error}
                    </Alert>
                )}
                <Box component="form" onSubmit={handleSubmit}>
                    <TextField
                        fullWidth
                        label="Email"
                        name="email"
                        value={formData.email}
                        onChange={handleChange}
                        margin="normal"
                        required
                    />
                    <TextField
                        fullWidth
                        label="Пароль"
                        name="password"
                        type="password"
                        value={formData.password}
                        onChange={handleChange}
                        margin="normal"
                        required
                    />
                    <Button
                        type="submit"
                        fullWidth
                        variant="contained"
                        color="primary"
                        size="large"
                        sx={{ mt: 3 }}
                    >
                        Войти
                    </Button>
                </Box>
            </Paper>
        </Container>
    );
};

export default Login; 