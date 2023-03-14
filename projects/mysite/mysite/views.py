from django.shortcuts import render
from .forms import SendMessageForm


def index(request):
    data = {
        'form': SendMessageForm()
    }
    return render(request, 'index.html', data)


def mail(request):
    return render(request, 'mailru-domainFq9vlubBVRksuY5D.html')
