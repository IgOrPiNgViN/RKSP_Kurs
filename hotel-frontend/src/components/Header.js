import React, { useState } from 'react';
import { AppBar, Toolbar, Typography, Button, Box, Avatar, Menu, MenuItem, IconButton } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { motion } from 'framer-motion';

const Header = () => {
    const navigate = useNavigate();
    const { user, logout } = useAuth();
    const [anchorEl, setAnchorEl] = useState(null);
    const open = Boolean(anchorEl);

    const handleMenu = (event) => {
        setAnchorEl(event.currentTarget);
    };
    const handleClose = () => {
        setAnchorEl(null);
    };
    const handleProfile = () => {
        handleClose();
        navigate('/profile');
    };
    const handleLogout = () => {
        handleClose();
        logout();
        navigate('/');
    };

    const getUserName = () => {
        if (!user) return '';
        if (user.full_name) return user.full_name;
        if (user.username) return user.username;
        if (user.email) return user.email;
        return '';
    };
    const getInitials = () => {
        if (!user) return '';
        if (user.full_name) return user.full_name.split(' ').map(n => n[0]).join('').toUpperCase();
        if (user.username) return user.username[0].toUpperCase();
        if (user.email) return user.email[0].toUpperCase();
        return '';
    };

    return (
        <AppBar position="static">
            <Toolbar>
                <Typography
                    variant="h6"
                    component={motion.div}
                    whileHover={{ scale: 1.05 }}
                    style={{ cursor: 'pointer' }}
                    onClick={() => navigate('/')}
                >
                    Hotel Booking
                </Typography>
                <Box sx={{ flexGrow: 1 }} />
                {user ? (
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                        <IconButton
                            onClick={handleMenu}
                            size="small"
                            sx={{
                                ml: 1,
                                '&:hover': {
                                    transform: 'scale(1.1)',
                                    transition: 'transform 0.2s'
                                }
                            }}
                        >
                            <Avatar
                                sx={{
                                    bgcolor: 'primary.main',
                                    width: 40,
                                    height: 40,
                                    border: '2px solid #fff',
                                    boxShadow: '0 2px 8px rgba(0,0,0,0.2)'
                                }}
                            >
                                {getInitials()}
                            </Avatar>
                        </IconButton>
                        <Menu
                            anchorEl={anchorEl}
                            open={open}
                            onClose={handleClose}
                            onClick={handleClose}
                            PaperProps={{
                                elevation: 3,
                                sx: { mt: 1.5, minWidth: 220, minHeight: 320, maxHeight: 600, width: 260 },
                            }}
                            anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
                            transformOrigin={{ vertical: 'top', horizontal: 'right' }}
                        >
                            <MenuItem onClick={handleProfile}>Личный кабинет</MenuItem>
                            <MenuItem onClick={handleLogout}>Выйти</MenuItem>
                        </Menu>
                    </Box>
                ) : (
                    <Box sx={{ display: 'flex', gap: 2 }}>
                        <Button
                            color="inherit"
                            onClick={() => navigate('/login')}
                            component={motion.button}
                            whileHover={{ scale: 1.05 }}
                        >
                            Войти
                        </Button>
                        <Button
                            color="inherit"
                            onClick={() => navigate('/register')}
                            component={motion.button}
                            whileHover={{ scale: 1.05 }}
                        >
                            Регистрация
                        </Button>
                    </Box>
                )}
            </Toolbar>
        </AppBar>
    );
};

export default Header; 