Настройки тестового режима:

В классе AppTestModeSettings:

isMockNetworkLayerOn - Включить/выключить взаимодействие с моковым сервером

(При выключении применяется продовая реализация сетевого репозитория )

класс HTTPRequestNetworkWorker - продовая реализация

класс MockHTTPRequestNetworkWorker - тестовая реализация

mockServerResponseDelayTime - Время до получения ответа от мокового сервера

mockRequestCanFail - Могут ли моковые запросы возвращать ошибку

mockSuccessfullServerResponsesConfiguration - Какой формат ответа возвращает моковый сервер (Подходящий/неподходящий клиенту либо оба варианта)

