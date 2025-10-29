"""
Point d'entrée de l'application Daily Quote
"""

from app import create_app
from app.config import Config

# Créer l'application
app = create_app()

if __name__ == '__main__':
    # Démarrer le serveur Flask
    app.run(
        host=Config.HOST,
        port=Config.PORT,
        debug=True
    )