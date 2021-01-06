from app.config import config


def get_log_level() -> bool:
    return config.LOG_LEVEL


def main() -> None:
    print(f"LOG_LEVEL: {get_log_level()}")


if __name__ == "__main__":
    main()
