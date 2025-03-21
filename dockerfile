FROM python:3.9-slim

WORKDIR /app

# Instalar dependências do sistema necessárias para PyMuPDF
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Copiar e instalar dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o código
COPY . .

# Porta padrão do Cloud Run
EXPOSE 8080

# Variável de ambiente para o nome da função
ENV FUNCTION_NAME=pdf_to_images

# Comando para iniciar o servidor
CMD exec gunicorn --bind :8080 --workers 1 --threads 8 --timeout 0 main:pdf_to_images
