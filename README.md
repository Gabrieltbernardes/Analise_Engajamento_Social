# Social Media Engagement Analysis via SQL

Este projeto utiliza um dataset de redes sociais para explorar o comportamento de usuários e o desempenho de marcas, campanhas e conteúdos postados em diferentes plataformas digitais. As análises são realizadas inteiramente via **SQL**, com base em um banco de dados relacional.

---

## Dataset

**Fonte:** [Social Media Engagement Dataset - Kaggle](https://www.kaggle.com)  
**Descrição:** Conjunto de dados que registra informações detalhadas sobre postagens em redes sociais, como:

- 📅 Data/hora, dia da semana, localização e idioma
- 📱 Plataforma e autor da postagem
- 📝 Conteúdo textual, hashtags, menções e palavras-chave
- 🎯 Categoria temática, pontuação e rótulo de sentimento, emoção predominante
- 🔥 Nível de toxicidade
- 📈 Métricas de engajamento: curtidas, compartilhamentos, comentários, impressões, taxa de engajamento
- 🏷️ Informações de marca, produto e campanha

---

## Justificativa

Este dataset foi escolhido por:

- **Atualidade:** marketing digital é altamente relevante
- **Riqueza:** dados variados e completos, com texto, métricas e categorias
- **Aplicabilidade:** simula campanhas reais e possibilita análises práticas de alto valor

---

## Modelo Relacional

```sql
Tabela principal: posts
- post_id (PK), timestamp, day_of_week, platform, user_id
- location, language, text_content, hashtags
- topic_category, sentiment_score, sentiment_label
- emotion_type, toxicity_score
- likes_count, shares_count, comments_count, impressions
- brand_name
Tabelas Derivadas:
eficiencia_real_plataforma
melhor_dia_interacao_por_marca
emocao_critica_por_topico
saude_semanal_marca
comparativo_google_vs_microsoft
focos_crise_intensidade_geografica
