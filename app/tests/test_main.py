def test_get_log_level():
    from app.main import get_log_level

    expected = "INFO"
    actual = get_log_level()
    assert expected == actual


def test_dependencies():
    import peppercorn
