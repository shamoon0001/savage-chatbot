from django.http import JsonResponse
from .responses import get_savage_reply

def chatbot_response(request):
    user_message = request.GET.get('message', '').strip()

    if not user_message:
        return JsonResponse({'bot_response': "Say something, or are you already speechless? 😂"})

    bot_reply = get_savage_reply()
    return JsonResponse({'bot_response': bot_reply})
