from django.urls import path
from .views import chatbot_response
from .views import chatbot_response, chat_history

urlpatterns = [
    path('chatbot-response/', chatbot_response, name='chatbot-response'),
    path('chat-history/', chat_history, name="chat_history"),
]
