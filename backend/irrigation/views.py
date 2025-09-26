from rest_framework import viewsets, generics, permissions, status
from rest_framework.decorators import action
from django.template.loader import render_to_string
from rest_framework.response import Response
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth.models import User
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from .models import Sensor, ProgramacionRiego, ActivacionUsuario, RegistroRiego, LecturaSensor, Cultivo, Finca
from django.core.validators import validate_email
from django.core.exceptions import ValidationError
from django.core.mail import send_mail, EmailMultiAlternatives
from django.urls import reverse
from django.conf import settings
from django.shortcuts import get_object_or_404
from django.utils.timezone import now, timedelta
from django.db.models import Avg, Min, Max
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.encoding import force_bytes
from django.contrib.auth.hashers import make_password
from .serializers import (
    SensorSerializer,
    ProgramacionRiegoSerializer,
    UserRegisterSerializer,
    EmailTokenObtainPairSerializer,
    UserDetailSerializer,
    UserDetailSerializer1,
    ProgramacionRiegoAdminSerializer,
    RegistroRiegoSerializer,
    LecturaSensorSerializer,
    CultivoSerializer,
    FincaSerializer,
    PasswordResetSerializer,
)


class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (permissions.AllowAny,)
    serializer_class = UserRegisterSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()

            # Crear token de activación
            token_obj = ActivacionUsuario.objects.create(user=user)

            # Construir URL absoluto para activar cuenta
            url_activacion = request.build_absolute_uri(
                reverse('activar-cuenta', kwargs={'token': str(token_obj.token)})
            )

            # Enviar email de activación
            asunto = 'Activa tu cuenta'
            mensaje = f'Hola {user.first_name}, gracias por registrarte. Por favor activa tu cuenta haciendo click en el siguiente enlace: {url_activacion}'
            send_mail(
                asunto,
                mensaje,
                settings.DEFAULT_FROM_EMAIL,
                [user.email],
                fail_silently=False,
            )

            return Response(
                {"mensaje": "Registro exitoso. Revisa tu email para activar la cuenta."},
                status=status.HTTP_201_CREATED
            )
        else:
            return Response(
                {"error": "Error en el registro", "detalles": serializer.errors},
                status=status.HTTP_400_BAD_REQUEST
            )

class ActivarCuentaView(APIView):
    permission_classes = (permissions.AllowAny,)

    def get(self, request, token):
        token_obj = get_object_or_404(ActivacionUsuario, token=token)
        
        if token_obj.esta_expirado():
            return Response({'error': 'El enlace de activación expiró.'}, status=status.HTTP_400_BAD_REQUEST)

        user = token_obj.user
        user.is_active = True
        user.save()

        token_obj.delete()

        return Response({'mensaje': 'Cuenta activada exitosamente.'}, status=status.HTTP_200_OK)

class CustomLoginView(TokenObtainPairView):
    permission_classes = (permissions.AllowAny,)
    serializer_class = EmailTokenObtainPairSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        try:
            serializer.is_valid(raise_exception=True)
        except ValidationError as exc:
            return Response({
                "error": "Credenciales inválidas",
                "detalles": exc.detail
            }, status=status.HTTP_401_UNAUTHORIZED)

        data = serializer.validated_data
        email = request.data.get('email', '')
        
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            user = None
             
        if user:
            token_generator = PasswordResetTokenGenerator()
            token = token_generator.make_token(user)
            uid = urlsafe_base64_encode(force_bytes(user.pk))

            print(f"DEBUG -> Token: {token}, UID: {uid}")


            context = {
            'username': user.first_name,
            'token': token,
            'uid': uid,
}


            subject = 'Token para restablecer tu contraseña'
            from_email = settings.DEFAULT_FROM_EMAIL
            to_email = user.email


            text_content = render_to_string('email/user_reset_password.txt', context)
            html_content = render_to_string('email/user_reset_password.html', context)

            msg = EmailMultiAlternatives(subject, text_content, from_email, [to_email])
            msg.attach_alternative(html_content, "text/html")
            msg.send()
            password_reset_url = request.build_absolute_uri('/api/password_reset/')
            
        return Response({
            "mensaje": f"¡Bienvenido, {email}!",
            "access": data.get("access"),
            "refresh": data.get("refresh"),
            "password_reset_url": password_reset_url,
        })


class AccesoValidateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response({"mensaje": "Acceso concedido. Token válido y autenticación correcta."})


class SensorViewSet(viewsets.ModelViewSet):
    queryset = Sensor.objects.all().order_by('-fecha_registro')
    serializer_class = SensorSerializer

    @action(detail=True, methods=['post'])
    def toggle(self, request, pk=None):
        sensor = self.get_object()
        sensor.activo = not sensor.activo
        sensor.save()

        if sensor.activo:
            # enviar señal para activar rociador
            mensaje_estado = 'Rociador activado'
            # tu_logica_para_activar(sensor)
        else:
            # enviar señal para desactivar rociador
            mensaje_estado = 'Rociador desactivado'
            # tu_logica_para_desactivar(sensor)

        return Response({'mensaje': mensaje_estado, 'estado': sensor.activo}, status=status.HTTP_200_OK)

    @action(detail=True, methods=['post'])
    def activar(self, request, pk=None):
        sensor = self.get_object()
        sensor.activo = True
        sensor.save()
        return Response({'mensaje': 'Rociador activado'}, status=status.HTTP_200_OK)
    
    @action(detail=True, methods=['post'])
    def desactivar(self, request, pk=None):
        sensor = self.get_object()
        sensor.activo = False
        sensor.save()
        return Response({'mensaje': 'Rociador desactivado'}, status=status.HTTP_200_OK)

class UserDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = UserDetailSerializer(request.user)
        return Response(serializer.data)
    
class ProgramacionRiegoViewSet(viewsets.ModelViewSet):
    queryset = ProgramacionRiego.objects.filter(activo=True)
    serializer_class = ProgramacionRiegoSerializer
    permission_classes = [permissions.IsAuthenticated]

    @action(detail=True, methods=['post'])
    def activar_riego(self, request, pk=None):
        programacion = self.get_object()
        # Aquí podrías agregar la lógica real para activar el riego mediante hardware

        return Response({'mensaje': f'Riego activado por {programacion.duracion} minutos'})

class ProgramacionRiegoAdminViewSet(viewsets.ModelViewSet):
    """
    Endpoint para listar, modificar y eliminar todas las programaciones de riego,
    sin filtrado (todas activas e inactivas).
    """
    queryset = ProgramacionRiego.objects.all().order_by('-inicio')
    serializer_class = ProgramacionRiegoAdminSerializer

class RegistroRiegoViewSet(viewsets.ModelViewSet):
    queryset = RegistroRiego.objects.all().order_by('-inicio')
    serializer_class = RegistroRiegoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)

class LecturasHumedadList(generics.ListAPIView):
    serializer_class = LecturaSensorSerializer

    def get_queryset(self):
        queryset = LecturaSensor.objects.all().order_by('-fecha_registro')
        cultivo_id = self.request.query_params.get('cultivo')
        if cultivo_id is not None:
            queryset = queryset.filter(cultivo_id=cultivo_id)
        return queryset
    
class EstadisticasHumedadSemanal(APIView):
    def get(self, request):
        fecha_fin = now()
        fecha_inicio = fecha_fin - timedelta(days=7)

        humedad_sensores = Sensor.objects.filter(tipo=Sensor.HUMEDAD)
        lecturas = LecturaSensor.objects.filter(sensor__in=humedad_sensores,
                                                fecha_registro__range=(fecha_inicio, fecha_fin))

        promedio = lecturas.aggregate(promedio=Avg('valor'))['promedio']
        minimo = lecturas.aggregate(minimo=Min('valor'))['minimo']
        maximo = lecturas.aggregate(maximo=Max('valor'))['maximo']

        return Response({
            'fecha_inicio': fecha_inicio,
            'fecha_fin': fecha_fin,
            'promedio_humedad': promedio,
            'minimo_humedad': minimo,
            'maximo_humedad': maximo,
        })

class CultivoViewSet(viewsets.ModelViewSet):
    queryset = Cultivo.objects.all().order_by('-created_at')
    serializer_class = CultivoSerializer

class LogoutView(APIView):

    def post(self, request):
        request.user.auth_token.delete()
        return Response({"message": "Sesión cerrada correctamente"}, status=200)
    
class InfoFincaView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        finca = Finca.objects.first()
        if not finca:
            return Response({'error': 'No hay datos de la finca registrados.'}, status=404)
        serializer = FincaSerializer(finca)
        return Response(serializer.data)

class UserDetailView1(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = UserDetailSerializer1(request.user)
        return Response(serializer.data)
    
class InfoFincaEditarView(generics.RetrieveUpdateAPIView):
    queryset = Finca.objects.all()
    serializer_class = FincaSerializer

    def get_object(self):
        # Retorna la primera finca o crea una nueva si no existe
        obj, created = Finca.objects.get_or_create(pk=1, defaults={
            'nombre': '',
            'direccion': '',
            'presentacion': '',
        })
        return obj
    
class UserUpdateView(generics.RetrieveUpdateAPIView):
    serializer_class = UserDetailSerializer1
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user
    
class CustomPasswordResetView(APIView):
    """Vista personalizada para solicitar reset de contraseña - Con tokens personalizados en BD"""
    permission_classes = [AllowAny]
    
    def post(self, request):
        from .models import TokenRestablecimiento
        
        serializer = PasswordResetSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            
            try:
                user = User.objects.get(email=email)
                
                # Crear token personalizado y guardarlo en BD
                print(f"DEBUG -> Creando token para usuario: {user.email}")
                token_obj = TokenRestablecimiento.create_for_user(user)
                token = token_obj.token
                
                # Verificar que el token se creó correctamente
                print(f"DEBUG RESET -> Token creado: {token}")
                print(f"DEBUG RESET -> Token ID en BD: {token_obj.id}")
                print(f"DEBUG RESET -> Token válido: {token_obj.is_valid()}")
                
                # Preparar contexto para el template
                context = {
                    'username': user.first_name or user.username,
                    'first_name': user.first_name or user.username,
                    'email': user.email,
                    'token': token,
                    'uid': str(user.pk),
                    'reset_password_token': token,
                    'site_name': 'PlantIQ - Sistema de Riego',
                }
                
                # Verificar contexto antes de enviar
                print(f"DEBUG CONTEXT -> Contexto completo: {context}")
                print(f"DEBUG CONTEXT -> Token en contexto: '{context.get('token')}'")
                print(f"DEBUG CONTEXT -> UID en contexto: '{context.get('uid')}'")
                
                # Enviar email exactamente como en login
                subject = 'Restablecimiento de Contraseña - PlantIQ'
                from_email = settings.DEFAULT_FROM_EMAIL
                to_email = user.email
                
                try:
                    # Renderizar plantillas
                    text_content = render_to_string('email/user_reset_password.txt', context)
                    html_content = render_to_string('email/user_reset_password.html', context)
                    
                    # Enviar email
                    msg = EmailMultiAlternatives(subject, text_content, from_email, [to_email])
                    msg.attach_alternative(html_content, "text/html")
                    msg.send()
                    
                    print(f"Email de reset enviado exitosamente a {email}")
                    
                except Exception as e:
                    print(f"Error enviando email: {str(e)}")
                    return Response({
                        "error": f"Error enviando email: {str(e)}"
                    }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
                
                # URL para confirmar el reset
                password_reset_confirm_url = request.build_absolute_uri('/api/password_reset/confirm')
                
                return Response({
                    "mensaje": f"Se ha enviado un email de restablecimiento a {email}. Revisa tu bandeja de entrada.",
                    "email": email,
                    "token_debug": token,  # Token personalizado guardado en BD
                    "uid_debug": str(user.pk),  # ID del usuario
                    "token_id": token_obj.id,  # ID del token en BD para referencia
                    "expira": token_obj.expira.isoformat(),  # Fecha de expiración
                    "password_reset_confirm_url": password_reset_confirm_url
                }, status=status.HTTP_200_OK)
                
            except User.DoesNotExist:
                return Response({
                    "error": "No existe un usuario con ese email."
                }, status=status.HTTP_400_BAD_REQUEST)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CustomPasswordResetConfirmView(APIView):
    """Vista personalizada para confirmar reset de contraseña con tokens personalizados"""
    permission_classes = [AllowAny]
    
    def post(self, request):
        from .models import TokenRestablecimiento
        
        # Obtener datos del request
        token = request.data.get('token')
        uid = request.data.get('uid')
        password = request.data.get('password')
        password_confirm = request.data.get('password_confirm')
        
        # Validar datos requeridos
        if not all([token, uid, password, password_confirm]):
            return Response({
                'error': 'Faltan datos requeridos: token, uid, password y password_confirm'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Validar que las contraseñas coincidan
        if password != password_confirm:
            return Response({
                'error': 'Las contraseñas no coinciden'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Validar longitud de contraseña
        if len(password) < 8:
            return Response({
                'error': 'La contraseña debe tener al menos 8 caracteres'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            # Buscar el token en la base de datos
            token_obj = TokenRestablecimiento.objects.get(
                token=token,
                user_id=uid,
                usado=False
            )
        except TokenRestablecimiento.DoesNotExist:
            return Response({
                'error': 'Token inválido o ya utilizado'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Verificar si el token ha expirado
        if token_obj.is_expired():
            token_obj.delete()  # Limpiar token expirado
            return Response({
                'error': 'El token ha expirado. Solicita un nuevo restablecimiento de contraseña.'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Actualizar la contraseña
        user = token_obj.user
        user.set_password(password)
        user.save()
        
        # Marcar token como usado
        token_obj.usado = True
        token_obj.save()
        
        print(f"DEBUG CONFIRM -> Contraseña cambiada para usuario: {user.email} con token: {token}")
        
        return Response({
            'mensaje': 'Contraseña restablecida exitosamente. Ahora puedes iniciar sesión con tu nueva contraseña.',
            'email': user.email
        }, status=status.HTTP_200_OK)
