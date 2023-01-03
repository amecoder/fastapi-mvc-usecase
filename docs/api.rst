:tocdepth: 2
API
===

This part of the documentation lists the full API reference of all classes and functions.

WSGI
----

.. autoclass:: fastapi_mvc_usecase.wsgi.ApplicationLoader
   :members:
   :show-inheritance:

Config
------

.. automodule:: fastapi_mvc_usecase.config

.. autoclass:: fastapi_mvc_usecase.config.application.Application
   :members:
   :show-inheritance:

.. autoclass:: fastapi_mvc_usecase.config.redis.Redis
   :members:
   :show-inheritance:

.. automodule:: fastapi_mvc_usecase.config.gunicorn

CLI
---

.. automodule:: fastapi_mvc_usecase.cli

.. autofunction:: fastapi_mvc_usecase.cli.cli.cli

.. autofunction:: fastapi_mvc_usecase.cli.utils.validate_directory

.. autofunction:: fastapi_mvc_usecase.cli.serve.serve

App
---

.. automodule:: fastapi_mvc_usecase.app

.. autofunction:: fastapi_mvc_usecase.app.asgi.on_startup

.. autofunction:: fastapi_mvc_usecase.app.asgi.on_shutdown

.. autofunction:: fastapi_mvc_usecase.app.asgi.get_application

.. automodule:: fastapi_mvc_usecase.app.router

Controllers
~~~~~~~~~~~

.. automodule:: fastapi_mvc_usecase.app.controllers

.. autofunction:: fastapi_mvc_usecase.app.controllers.ready.readiness_check

Models
~~~~~~

.. automodule:: fastapi_mvc_usecase.app.models

Views
~~~~~

.. automodule:: fastapi_mvc_usecase.app.views

.. autoclass:: fastapi_mvc_usecase.app.views.error.ErrorModel
   :members:
   :show-inheritance:

.. autoclass:: fastapi_mvc_usecase.app.views.error.ErrorResponse
   :members:
   :show-inheritance:

Exceptions
~~~~~~~~~~

.. automodule:: fastapi_mvc_usecase.app.exceptions

.. autoclass:: fastapi_mvc_usecase.app.exceptions.http.HTTPException
   :members:
   :show-inheritance:

.. autofunction:: fastapi_mvc_usecase.app.exceptions.http.http_exception_handler

Utils
~~~~~

.. automodule:: fastapi_mvc_usecase.app.utils

.. autoclass:: fastapi_mvc_usecase.app.utils.aiohttp_client.AiohttpClient
   :members:
   :show-inheritance:

.. autoclass:: fastapi_mvc_usecase.app.utils.redis.RedisClient
   :members:
   :show-inheritance:
