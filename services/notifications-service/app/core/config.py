from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    SERVICE_NAME: str = "notifications-service"
    VERSION: str = "0.1.0"
    APP_ENV: str = "development"
    PORT: int = 8004
    LOG_LEVEL: str = "info"
    CORS_ORIGINS: list[str] = ["http://localhost:3000"]

    # Redis
    REDIS_URL: str = "redis://localhost:6379/0"

    # SMTP
    SMTP_HOST: str = "localhost"
    SMTP_PORT: int = 587
    SMTP_USER: str = ""
    SMTP_PASSWORD: str = ""
    SMTP_FROM_EMAIL: str = "noreply@system-for-llms.example.com"


settings = Settings()
