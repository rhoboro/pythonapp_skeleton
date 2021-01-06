"""Config情報をpythonファイルとして定義したモジュール."""

import importlib
import os
from collections import UserDict
from typing import Any


class _Config(UserDict):
    """Config情報をオブジェクトのpropertyとして展開するクラス."""

    def __getattr__(self, item: str) -> Any:
        return self.data.get(item)

    def __setattr__(self, key: str, value: str) -> None:
        super().__setattr__(key, value)


_config = importlib.import_module("app.config.{}".format(os.environ["APP_CONFIG_FILE"]))
config = _Config(**{k: getattr(_config, k) for k in dir(_config) if not k.startswith("__")})
