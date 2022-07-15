from django.shortcuts import render
from .forms import SendMessageForm


def index(request):
    data = {
        'form': SendMessageForm()
    }
    return render(request, 'index.html', data)
