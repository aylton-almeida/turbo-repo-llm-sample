from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    SERVICE_NAME: str = "users-service"
    VERSION: str = "0.1.0"
    APP_ENV: str = "development"
    PORT: int = 8002
    LOG_LEVEL: str = "info"
    CORS_ORIGINS: list[str] = ["http://localhost:3000"]

    # Database
    DATABASE_URL: str = "postgresql+asyncpg://mono:mono_dev_password@localhost:5432/mono_db"


settings = Settings()
