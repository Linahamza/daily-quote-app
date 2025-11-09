"""
Routes de l'API Daily Quote
Définit les endpoints HTTP
"""

from flask import Blueprint, jsonify
from app.services import QuoteService

# Créer un Blueprint (groupe de routes)
api = Blueprint('api', __name__, url_prefix='/api')


@api.route('/quote', methods=['GET'])
def get_quote():
    """GET /api/quote - Retourne une citation aléatoire"""
    try:
        quote = QuoteService.get_random_quote()
        return jsonify(quote), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@api.route('/quote/author/<author_name>', methods=['GET'])
def get_quote_by_author(author_name):
    """GET /api/quote/author/<name> - Citation d'un auteur"""
    try:
        quote = QuoteService.get_quote_by_author(author_name)
        return jsonify(quote), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@api.route('/health', methods=['GET'])
def health_check():
    """GET /api/health - Health check"""
    return jsonify({
        'status': 'healthy',
        'service': 'daily-quote-api',
        'version': '2.0.0', # ← Changé de 1.0.3 à 2.0.0
         'ci_cd': 'GitHub Actions'  # ← Ajout
    }), 200