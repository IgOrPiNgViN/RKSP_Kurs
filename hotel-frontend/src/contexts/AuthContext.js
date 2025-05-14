import React, { createContext, useState, useContext, useEffect } from 'react';
import axios from 'axios';

const AuthContext = createContext(null);

export const useAuth = () => useContext(AuthContext);

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(false);
    const [accessToken, setAccessToken] = useState(null);
    const [refreshToken, setRefreshToken] = useState(null);

    const setAuthHeader = (token) => {
        if (token) {
            axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
        } else {
            delete axios.defaults.headers.common['Authorization'];
        }
    };

    const refreshAccessToken = async () => {
        console.log('refreshToken перед обновлением:', refreshToken);
        if (!refreshToken) {
            alert('Ваша сессия истекла. Пожалуйста, войдите заново.');
            logout();
            return null;
        }
        try {
            const response = await axios.post('http://78.24.223.206:8086/api/token/refresh/', {
                refresh: refreshToken
            });
            const { access } = response.data;
            setAccessToken(access);
            localStorage.setItem('accessToken', access);
            setAuthHeader(access);
            console.log('accessToken после обновления:', access);
            return access;
        } catch (error) {
            alert('Ваша сессия истекла. Пожалуйста, войдите заново.');
            console.error('Token refresh failed:', error);
            logout();
            return null;
        }
    };

    useEffect(() => {
        // Восстанавливаем пользователя и токены из localStorage
        const savedUser = localStorage.getItem('user');
        const savedAccess = localStorage.getItem('accessToken');
        const savedRefresh = localStorage.getItem('refreshToken');

        if (savedUser) setUser(JSON.parse(savedUser));
        if (savedAccess) {
            setAccessToken(savedAccess);
            setAuthHeader(savedAccess);
        }
        if (savedRefresh) setRefreshToken(savedRefresh);
    }, []);

    const login = async (email, password) => {
        setLoading(true);
        try {
            const response = await axios.post('http://78.24.223.206:8086/api/token/', { email, password });
            const { access, refresh, user: userData } = response.data;
            setUser(userData);
            setAccessToken(access);
            setRefreshToken(refresh);
            localStorage.setItem('user', JSON.stringify(userData));
            localStorage.setItem('accessToken', access);
            localStorage.setItem('refreshToken', refresh);
            setAuthHeader(access);
            setLoading(false);
            console.log('accessToken после логина:', access);
            console.log('refreshToken после логина:', refresh);
            return true;
        } catch (error) {
            setLoading(false);
            throw error;
        }
    };

    const register = async (userData) => {
        try {
            await axios.post('http://78.24.223.206:8086/api/user/register/', userData);
            return true;
        } catch (error) {
            console.error('Registration error:', error);
            return false;
        }
    };

    const logout = () => {
        console.log('Выполнен logout. Токены и пользователь очищены.');
        localStorage.removeItem('user');
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        setUser(null);
        setAccessToken(null);
        setRefreshToken(null);
        setAuthHeader(null);
    };

    const value = {
        user,
        loading,
        login,
        register,
        logout,
        accessToken,
        refreshToken,
        refreshAccessToken,
        setUser
    };

    return (
        <AuthContext.Provider value={value}>
            {children}
        </AuthContext.Provider>
    );
}; 