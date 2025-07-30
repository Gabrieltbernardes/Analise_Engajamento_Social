-- Criando Banco de Dados "engajamento_rede_social"
CREATE database engajamento_rede_social;

-- Garantindo que estamos utilizando o Banco de Dados Criado
USE engajamento_rede_social;



-- Criando a Tabela com as informações necessárias 
CREATE TABLE posts (
    post_id VARCHAR(50) PRIMARY KEY, 
    timestamp DATETIME,
    day_of_week VARCHAR(20),
    platform VARCHAR(50),
    user_id VARCHAR(50), 
    location VARCHAR(100),
    language VARCHAR(50),
    topic_category VARCHAR(100),
    sentiment_label VARCHAR(20),
    emotion_type VARCHAR(50),
    likes_count INT,
    impressions INT,
    brand_name VARCHAR(100)
);

-- Importando as informações do Banco de Dados 
-- https://www.kaggle.com/datasets/subashmaster0411/social-media-engagement-dataset?resource=download
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Social_Dataset.csv'
INTO TABLE posts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

-- Importando somente os campos necessários
(post_id,timestamp,day_of_week,platform,user_id,location,language,@ignorar_text_content,@ignorar_hashtags,
@ignorar_mentions,@ignorar_keywords, topic_category, @ignorar_sentiment_score, sentiment_label,
emotion_type, @ignorar_toxicity_score, likes_count, @ignorar_shares_count, @ignorar_comments_count,
impressions, @ignorar_engagement_rate, brand_name, @ignorar_product_name, @ignorar_campaign_name,
@ignorar_campaign_phase, @ignorar_user_past_sentiment_avg, @ignorar_user_engagement_growth,
@ignorar_buzz_change_rate);

-- Tabela que responde a pergunta "Quais são as plataformas mais usadas?"
CREATE TABLE plataformas AS
SELECT
    platform AS plataforma,
    COUNT(*) AS quantidade_de_posts
FROM
    posts
GROUP BY
    platform
ORDER BY
    quantidade_de_posts DESC;
    
-- Tabela que responde a pergunta "Quais são as linguagens mais usadas?"
CREATE TABLE linguagens AS
SELECT
    language AS idioma,
    COUNT(*) AS quantidade_de_posts
FROM
    posts
GROUP BY
    language
ORDER BY
    quantidade_de_posts DESC;
    
-- Tabela que responde a pergunta "Quais são os tópicos mais presentes?"
CREATE TABLE topicos AS
SELECT
    topic_category AS categoria_do_topico,
    COUNT(*) AS quantidade_de_posts
FROM
    posts
GROUP BY
    topic_category
ORDER BY
    quantidade_de_posts DESC;
    
-- Tabela que responde a pergunta "Quais são as marcas com mais likes?"
CREATE TABLE likes_por_marca AS
SELECT
    brand_name AS marca,
    SUM(likes_count) AS total_de_likes
FROM
    posts
WHERE
    brand_name IS NOT NULL AND brand_name != ''
GROUP BY
    brand_name
ORDER BY
    total_de_likes DESC;
    
-- Tabela que responde a pergunta "Quais foram os sentimentos das pessoas?"
CREATE TABLE sentimentos AS
SELECT
    sentiment_label AS sentimento,
    COUNT(*) AS quantidade
FROM
    posts
GROUP BY
    sentiment_label
ORDER BY
    quantidade DESC;
    
-- Tabela que responde a pergunta "Quais foram as emoções sentidas?"
CREATE TABLE emocoes AS
SELECT
    emotion_type AS tipo_de_emocao,
    COUNT(*) AS quantidade
FROM
    posts
GROUP BY
    emotion_type
ORDER BY
    quantidade DESC;