from django import forms
# from snowpenguin.django.recaptcha3.fields import ReCaptchaField


class SendMessageForm(forms.Form):
    # captcha = ReCaptchaField()

    name = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Your Name'
    }))
    email_or_phone = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Your Email or Phone number'
    }))
    subject = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Subject'
    }))
    message = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'placeholder': 'Message',
        'rows': '5'
    }))
