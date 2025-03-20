from django.http import JsonResponse
from .models import ChatMessage
from .serializers import ChatMessageSerializer
from .responses import get_savage_reply
from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(['GET'])
def chatbot_response(request):
    user_message = request.GET.get('message', '').strip()

    if not user_message:
        bot_reply = "Say something, or are you already speechless? 😂"
    else:
        bot_reply = get_savage_reply()

        # Save user message and bot reply in history
        ChatMessage.objects.create(sender="User", message=user_message)
        ChatMessage.objects.create(sender="ShanaAi", message=bot_reply)

    return JsonResponse({'bot_response': bot_reply}, json_dumps_params={'ensure_ascii': False})

@api_view(['GET'])
def chat_history(request):
    """Fetch last 50 chat messages"""
    messages = ChatMessage.objects.all().order_by('-timestamp')[:50]  # Fetch latest 50 messages
    serializer = ChatMessageSerializer(messages, many=True)
    return Response(serializer.data)






# import openai
# import random
# from django.http import JsonResponse
# from django.conf import settings
# from .models import ChatMessage
#
# # Set your OpenAI API key
# openai.api_key = "YOUR_OPENAI_API_KEY"  # Replace with your key
#
# # Fallback savage roasts (if AI fails)
# FALLBACK_RESPONSES = [
#     "Your brain’s on airplane mode again, isn’t it?",
#     "You're proof that WiFi signals don’t reach everyone.",
#     "Is your battery low? Because your energy is nonexistent.",
#     "If you were any slower, you'd be going in reverse.",
#     "I’d roast you more, but even fire doesn’t waste time on useless things.",
# ]
#
# def generate_savage_reply(user_message):
#     """Generates a savage but non-vulgar roast using OpenAI GPT API"""
#     try:
#         response = openai.ChatCompletion.create(
#             model="gpt-4-turbo",  # Use GPT-4 Turbo for fast responses
#             messages=[
#                 {"role": "system", "content": "You are a savage AI that roasts users in a funny but non-vulgar way."},
#                 {"role": "user", "content": user_message}
#             ],
#             max_tokens=50
#         )
#         return response["choices"][0]["message"]["content"].strip()
#     except Exception as e:
#         print("OpenAI Error:", e)
#         return random.choice(FALLBACK_RESPONSES)
#
# def chatbot_response(request):
#     """Returns a savage AI-generated roast"""
#     user_message = request.GET.get("message", "").strip()
#
#     if not user_message:
#         return JsonResponse({"error": "Message cannot be empty"}, status=400)
#
#     # Generate AI-based savage roast
#     bot_reply = generate_savage_reply(user_message)
#
#     # Save chat in the database
#     ChatMessage.objects.create(user_message=user_message, bot_response=bot_reply)
#
#     return JsonResponse({"user_message": user_message, "bot_response": bot_reply})
