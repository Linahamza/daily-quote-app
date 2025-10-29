"""
Services de l'application Daily Quote
Contient la logique métier (appels API, traitement)
"""

import requests
from flask import current_app


class QuoteService:
    """Service pour récupérer des citations"""
    
    @staticmethod
    def get_random_quote():
        """
        Récupère une citation aléatoire depuis Quotable.io
        
        Returns:
            dict: Citation avec quote, author et tags
        """
        try:
            api_url = current_app.config['QUOTABLE_API_URL']
            timeout = current_app.config['API_TIMEOUT']
            
            response = requests.get(f'{api_url}/random', timeout=timeout)
            response.raise_for_status()
            
            data = response.json()
            return {
                'quote': data.get('content', ''),
                'author': data.get('author', 'Unknown'),
                'tags': data.get('tags', [])
            }
            
        except Exception as e:
            raise Exception(f'Error fetching quote: {str(e)}')
    
    
    @staticmethod
    def get_quote_by_author(author_name):
        """
        Récupère une citation d'un auteur spécifique
        
        Args:
            author_name (str): Nom de l'auteur
            
        Returns:
            dict: Citation de l'auteur
        """
        try:
            api_url = current_app.config['QUOTABLE_API_URL']
            timeout = current_app.config['API_TIMEOUT']
            
            # ✅ CORRECTION : Utiliser /quotes au lieu de /random
            # /quotes retourne une liste, on prend le premier résultat
            response = requests.get(
                f'{api_url}/quotes',
                params={
                    'author': author_name,
                    'limit': 1  # On veut une seule citation
                },
                timeout=timeout
            )
            response.raise_for_status()
            
            data = response.json()
            
            # Vérifier si des résultats existent
            if data.get('count', 0) == 0 or not data.get('results'):
                raise Exception(f'No quotes found for author: {author_name}')
            
            # Prendre la première citation
            quote_data = data['results'][0]
            
            return {
                'quote': quote_data.get('content', ''),
                'author': quote_data.get('author', 'Unknown'),
                'tags': quote_data.get('tags', [])
            }
            
        except Exception as e:
            raise Exception(f'Error fetching quote by author: {str(e)}')