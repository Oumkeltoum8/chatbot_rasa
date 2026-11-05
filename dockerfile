# Image de base Python 3.8 (compatible avec Rasa 3.6.21)
FROM python:3.8-slim

# Définir le répertoire de travail
WORKDIR /app

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copier les fichiers de dépendances en premier (optimisation cache Docker)
COPY requirements.txt .

# Installer les dépendances Python
RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir psycopg2-binary==2.9.5 --only-binary :all: && \
    pip install --no-cache-dir -r requirements.txt

# Copier tout le projet
COPY . .

# Exposer le port Rasa
EXPOSE 5005

# Commande de démarrage
CMD ["rasa", "run", "--enable-api", "--cors", "*", "--port", "5005"]