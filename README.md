Настройки тестового режима:

В классе AppTestModeSettings:

class AppTestModeSettings {
    var isMockNetworkLayerOn = true
    var mockServerResponseDelayTime: Double = 4.0
    var mockRequestCanFail = true
    var mockSuccessfullServerResponsesConfiguration: MockSuccessfullServerResponsesConfiguration =
        .bothSuitableAndNotSuitableForTheClient
}

isMockNetworkLayerOn - Включить/выключить взаимодействие с моковым сервером
mockServerResponseDelayTime - Время до получения ответа от моквого сервера
mockRequestCanFail - Могут ли моковые запросы возвращать ошибку
mockSuccessfullServerResponsesConfiguration - Какой формат ответа возвращает моковый сервер (Подходящий/неподходящий клиенту либо оба варианта)
