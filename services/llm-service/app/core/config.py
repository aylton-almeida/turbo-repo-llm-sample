from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    SERVICE_NAME: str = "llm-service"
    VERSION: str = "0.1.0"
    APP_ENV: str = "development"
    PORT: int = 8003
    LOG_LEVEL: str = "info"
    CORS_ORIGINS: list[str] = ["http://localhost:3000"]

    # LLM Providers
    OPENAI_API_KEY: str
    ANTHROPIC_API_KEY: str = ""
    LLM_DEFAULT_MODEL: str = "gpt-4o"
    LLM_DEFAULT_TEMPERATURE: float = 0.7
    LLM_MAX_TOKENS: int = 4096


settings = Settings()  # type: ignore[call-arg]
