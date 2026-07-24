import os
from functools import lru_cache
from typing import List
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Configurações da aplicação"""

    # Database
    DATABASE_URL: str = "postgresql://user:password@localhost:5432/flowfiscal"
    DATABASE_HOST: str = "localhost"
    DATABASE_PORT: int = 5432
    DATABASE_USER: str = "flowfiscal_user"
    DATABASE_PASSWORD: str = "password"
    DATABASE_NAME: str = "flowfiscal"

    # API
    API_TITLE: str = "FlowFiscal ERP API"
    API_VERSION: str = "1.0.0"
    API_DESCRIPTION: str = "Sistema de gestão de notas fiscais"
    BACKEND_URL: str = "http://localhost:8000"
    BACKEND_PORT: int = 8000

    # Frontend
    FRONTEND_URL: str = "http://localhost:3000"
    NEXT_PUBLIC_API_URL: str = "http://localhost:8000"

    # JWT
    JWT_SECRET: str = "your_super_secret_jwt_key_change_in_production"
    JWT_ALGORITHM: str = "HS256"
    JWT_EXPIRATION_HOURS: int = 24
    JWT_REFRESH_EXPIRATION_DAYS: int = 7

    # CORS
    CORS_ORIGINS: List[str] = ["http://localhost:3000", "http://localhost:3001"]

    # Environment
    ENVIRONMENT: str = "development"
    DEBUG: bool = True

    # Email
    SMTP_SERVER: str = "smtp.gmail.com"
    SMTP_PORT: int = 587
    SMTP_USER: str = ""
    SMTP_PASSWORD: str = ""

    # AWS S3
    AWS_ACCESS_KEY_ID: str = ""
    AWS_SECRET_ACCESS_KEY: str = ""
    AWS_S3_BUCKET_NAME: str = "flowfiscal-docs"
    AWS_REGION: str = "us-east-1"

    # Logging
    LOG_LEVEL: str = "INFO"
    LOG_FORMAT: str = "json"

    # File upload
    ALLOWED_FILE_EXTENSIONS: List[str] = ["pdf", "xml", "xlsx", "xls"]
    MAX_FILE_SIZE_MB: int = 50

    class Config:
        env_file = ".env"
        case_sensitive = True


@lru_cache()
def get_settings() -> Settings:
    """Get cached settings instance"""
    return Settings()


settings = get_settings()
