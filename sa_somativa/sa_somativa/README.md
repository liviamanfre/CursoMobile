# SA Somativa - Aplicativo de Registro de Ponto

## 📋 Descrição Completa do Projeto
O **SA Somativa** é um aplicativo Flutter desenvolvido para registro de ponto de funcionários, utilizando **Firebase Authentication**, **Cloud Firestore** e **geolocalização**. O app garante que os registros sejam feitos apenas dentro de uma área autorizada de 100 metros.

---

## 🎯 Relatório de Implementação Técnica

### Arquitetura e Design Patterns
O projeto adota uma arquitetura modular baseada em serviços:
- **AuthService**: Autenticação Firebase
- **LocationService**: Geolocalização e cálculos
- **FirestoreService**: Operações de banco de dados

**Decisões de Design:**
- Uso de `StreamBuilder` para atualizações em tempo real
- Separação entre lógica de negócio (services) e UI (widgets)
- Padrão Singleton para serviços compartilhados
- Validação em camadas: frontend + backend

### Sistema de Autenticação
**Implementação:**
- Firebase Authentication com provedor email/senha
- Reautenticação obrigatória para operações críticas

**Fluxo de Segurança:**
```
Usuário loga → Tela Principal → Registro de Ponto → Confirmação de Senha → Validação Localização → Registro Firestore
```

### Sistema de Geolocalização
**APIs Utilizadas:**
- `geolocator: ^11.0.1` - Obtenção de coordenadas em tempo real

**Implementação:**
```dart
double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371e3;
  final phi1 = lat1 * math.pi / 180;
  final phi2 = lat2 * math.pi / 180;
  final deltaPhi = (lat2 - lat1) * math.pi / 180;
  final deltaLambda = (lon2 - lon1) * math.pi / 180;

  final a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
      math.cos(phi1) * math.cos(phi2) *
      math.sin(deltaLambda / 2) * math.sin(deltaLambda / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return R * c;
}
```

**Configuração:**
- Localização da empresa definida como constante
- Raio permitido: 100 metros
- Verificação de permissões em runtime

---

## 🛠 Especificação de APIs Externas

### 1. Firebase Services
**Firebase Authentication:**
- Método: `signInWithEmailAndPassword()`
- Método: `createUserWithEmailAndPassword()`
- Tratamento de erros: `FirebaseAuthException`

**Cloud Firestore:**
- Coleção: `pontos` (registros de ponto)
- Estrutura do documento:
```json
{
  "userId": "string",
  "tipo": "entrada|saida",
  "timestamp": "DateTime",
  "localizacao": {
    "lat": "double",
    "lng": "double",
    "endereco": "string"
  },
  "distancia": "double"
}
```

### 2. Geolocation API
**Geolocator Package:**
- Função: `getCurrentPosition()` - posição atual
- Função: `checkPermission()` - verificação de permissões
- Precisão: `LocationAccuracy.best`

**Geocoding Package:**
- Conversão coordenadas → endereço legível
- Função: `placemarkFromCoordinates()`

---

## 🚧 Desafios Técnicos Encontrados e Soluções

### Desafio 1: Gerenciamento de Estado de Autenticação
**Problema:** Transições entre telas de login/app principal
**Solução:**
```dart
return StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return PrincipalView();
    } else {
      return LoginView();
    }
  },
);
```

### Desafio 2: Validação de Localização em Tempo Real
**Problema:** Usuário pode se mover durante o processo de registro
**Solução:**
```dart
Future<bool> _validarLocalizacao() async {
  final posicao = await Geolocator.getCurrentPosition();
  final distancia = calcularDistancia(
    posicao.latitude, 
    posicao.longitude, 
    LOCALIZACAO_EMPRESA.latitude, 
    LOCALIZACAO_EMPRESA.longitude
  );
  return distancia <= 100.0;
}
```

### Desafio 3: Controle de Registros Duplicados
**Problema:** Usuário poderia registrar múltiplas entradas/saídas consecutivas
**Solução:**
```dart
void _atualizarBotoes(DocumentSnapshot? ultimoRegistro) {
  if (ultimoRegistro != null) {
    final ultimoTipo = ultimoRegistro['tipo'];
    setState(() {
      _botaoEntradaHabilitado = (ultimoTipo == 'saida');
      _botaoSaidaHabilitado = (ultimoTipo == 'entrada');
    });
  }
}
```

### Desafio 4: Performance do Firestore
**Problema:** Carregamento lento do histórico com muitos registros
**Solução:**
```dart
Stream<QuerySnapshot> _obterHistoricoUsuario() {
  return FirebaseFirestore.instance
      .collection('pontos')
      .where('userId', isEqualTo: _usuario?.uid)
      .orderBy('timestamp', descending: true)
      .limit(50)
      .snapshots();
}
```

---

## 📱 Funcionalidades Implementadas

| Funcionalidade | Status | Descrição |
|----------------|--------|------------|
| Autenticação de Usuário | ✅ | AuthWidget monitora estado do usuário via FirebaseAuth |
| Login e Registro | ✅ | Telas LoginView e RegistroView para autenticação |
| Registro de Ponto | ✅ | PontoView com validação de localização e confirmação de senha |
| Histórico de Pontos | ✅ | HistoricoView exibe registros em tempo real com StreamBuilder |
| Validação Geográfica | ✅ | Calcula distância e impede registros fora do limite |
| Segurança | ✅ | Reautenticação obrigatória para registro de ponto |

---

## 🚀 Guia Completo de Instalação e Configuração

### 1. PRÉ-REQUISITOS
- Flutter 3.0+ instalado
- Android Studio ou VSCode com Flutter Plugin
- Conta Google para Firebase
- Dispositivo Android/iOS ou emulador

### 2. CLONE E CONFIGURAÇÃO INICIAL
```bash
git clone https://github.com/pcfrati/sa_somativa.git
cd sa_somativa
flutter pub get
flutter doctor
```

### 3. CONFIGURAÇÃO DO FIREBASE

**Passo 3.1 - Criar Projeto Firebase:**
1. Acesse o Firebase Console
2. Clique em "Adicionar projeto"
3. Nomeie como "SA Somativa"

**Passo 3.2 - Configurar Authentication:**
1. No menu esquerdo, clique em "Authentication"
2. Vá para "Sign-in method"
3. Habilite "Email/Password"
4. Clique em "Salvar"

**Passo 3.3 - Configurar Firestore:**
1. No menu esquerdo, clique em "Firestore Database"
2. Clique em "Criar banco de dados"
3. Escolha "Modo de teste"
4. Selecione uma localização
5. Clique em "Pronto"

**Passo 3.4 - Configurar no Código:**
```bash
flutterfire configure
```

### 4. CONFIGURAÇÃO DE PERMISSÕES

**Para Android (`android/app/src/main/AndroidManifest.xml`):**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <application>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="SUA_CHAVE_API" />
    </application>
</manifest>
```

### 5. EXECUTANDO O APLICATIVO
```bash
# Para Android
flutter run
```

---

## 📊 Dependências Utilizadas
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.13.0
  geolocator: ^11.0.1
  geocoding: ^2.1.1
  intl: ^0.18.1
```

---
**Projeto desenvolvido para avaliação de competências em Flutter e Firebase.**
```
