from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    SERVICE_NAME: str = "api-gateway"
    VERSION: str = "0.1.0"
    APP_ENV: str = "development"
    PORT: int = 8000
    LOG_LEVEL: str = "info"
    CORS_ORIGINS: list[str] = ["http://localhost:3000"]

    # Upstream service URLs
    AUTH_SERVICE_URL: str = "http://localhost:8001"
    USERS_SERVICE_URL: str = "http://localhost:8002"
    LLM_SERVICE_URL: str = "http://localhost:8003"
    NOTIFICATIONS_SERVICE_URL: str = "http://localhost:8004"


settings = Settings()
