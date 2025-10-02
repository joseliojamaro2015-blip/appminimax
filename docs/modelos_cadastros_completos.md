# 📝 MODELOS DE CADASTROS COMPLETOS - SISTEMA APP LG
*Estruturas de Dados Detalhadas para Todas as Entidades*

---

## 🏢 1. EMPRESA (MATRIZ)

### **Campos Obrigatórios**
```json
{
  "id": "uuid",
  "razao_social": "string (required)",
  "nome_fantasia": "string (required)",
  "cnpj": "string (required, unique)",
  "inscricao_estadual": "string",
  "inscricao_municipal": "string",
  "regime_tributario": "enum (simples, presumido, real)",
  "atividade_principal": "string",
  "data_fundacao": "date",
  "status": "enum (ativa, inativa, suspensa)"
}
```

### **Endereço**
```json
{
  "endereco": {
    "cep": "string (required)",
    "logradouro": "string (required)",
    "numero": "string (required)",
    "complemento": "string",
    "bairro": "string (required)",
    "cidade": "string (required)",
    "estado": "string (required)",
    "pais": "string (default: Brasil)"
  }
}
```

### **Contatos**
```json
{
  "contatos": {
    "telefone_principal": "string (required)",
    "telefone_secundario": "string",
    "whatsapp": "string",
    "email_principal": "string (required)",
    "email_comercial": "string",
    "email_financeiro": "string",
    "website": "string",
    "redes_sociais": {
      "instagram": "string",
      "facebook": "string",
      "linkedin": "string"
    }
  }
}
```

### **Configurações**
```json
{
  "configuracoes": {
    "logo_url": "string",
    "cores_tema": {
      "primaria": "string",
      "secundaria": "string",
      "acento": "string"
    },
    "timezone": "string (default: America/Sao_Paulo)",
    "moeda": "string (default: BRL)",
    "idioma": "string (default: pt-BR)"
  }
}
```

---

## 🏪 2. FILIAIS

### **Campos Principais**
```json
{
  "id": "uuid",
  "empresa_id": "uuid (foreign_key)",
  "codigo_filial": "string (required, unique)",
  "nome": "string (required)",
  "cnpj": "string (unique)",
  "inscricao_estadual": "string",
  "inscricao_municipal": "string",
  "tipo": "enum (matriz, filial, franquia)",
  "status": "enum (ativa, inativa, manutencao)",
  "data_inauguracao": "date",
  "area_total_m2": "decimal",
  "capacidade_maxima": "integer"
}
```

### **Horários de Funcionamento**
```json
{
  "horarios": {
    "segunda": {"abertura": "time", "fechamento": "time", "ativo": "boolean"},
    "terca": {"abertura": "time", "fechamento": "time", "ativo": "boolean"},
    "quarta": {"abertura": "time", "fechamento": "time", "ativo": "boolean"},
    "quinta": {"abertura": "time", "fechamento": "time", "ativo": "boolean"},
    "sexta": {"abertura": "time", "fechamento": "time", "ativo": "boolean"},
    "sabado": {"abertura": "time", "fechamento": "time", "ativo": "boolean"},
    "domingo": {"abertura": "time", "fechamento": "time", "ativo": "boolean"}
  }
}
```

### **Equipamentos e Facilidades**
```json
{
  "facilidades": {
    "estacionamento": "boolean",
    "vestiario_masculino": "boolean",
    "vestiario_feminino": "boolean",
    "chuveiros": "integer",
    "armarios": "integer",
    "ar_condicionado": "boolean",
    "wifi": "boolean",
    "acessibilidade": "boolean",
    "equipamentos": [
      {
        "categoria": "string",
        "nome": "string",
        "quantidade": "integer",
        "status": "enum (ativo, manutencao, inativo)"
      }
    ]
  }
}
```

---

## 👤 3. PESSOA FÍSICA

### **Dados Pessoais**
```json
{
  "id": "uuid",
  "nome_completo": "string (required)",
  "nome_social": "string",
  "cpf": "string (required, unique)",
  "rg": "string",
  "rg_orgao_emissor": "string",
  "data_nascimento": "date (required)",
  "genero": "enum (masculino, feminino, nao_binario, nao_informado)",
  "estado_civil": "enum (solteiro, casado, divorciado, viuvo, uniao_estavel)",
  "nacionalidade": "string (default: brasileira)",
  "naturalidade": "string",
  "profissao": "string",
  "escolaridade": "enum (fundamental, medio, superior, pos_graduacao)"
}
```

### **Documentos Adicionais**
```json
{
  "documentos": {
    "cnh": {
      "numero": "string",
      "categoria": "string",
      "data_vencimento": "date"
    },
    "passaporte": {
      "numero": "string",
      "data_vencimento": "date"
    },
    "carteira_trabalho": {
      "numero": "string",
      "serie": "string"
    }
  }
}
```

### **Contatos**
```json
{
  "contatos": {
    "telefone_principal": "string (required)",
    "telefone_secundario": "string",
    "whatsapp": "string",
    "email_principal": "string (required)",
    "email_secundario": "string",
    "preferencia_contato": "enum (telefone, whatsapp, email, sms)"
  }
}
```

### **Endereços** (Múltiplos)
```json
{
  "enderecos": [
    {
      "tipo": "enum (residencial, comercial, correspondencia)",
      "cep": "string (required)",
      "logradouro": "string (required)",
      "numero": "string (required)",
      "complemento": "string",
      "bairro": "string (required)",
      "cidade": "string (required)",
      "estado": "string (required)",
      "pais": "string (default: Brasil)",
      "principal": "boolean"
    }
  ]
}
```

### **Informações Médicas Básicas**
```json
{
  "saude": {
    "tipo_sanguineo": "enum (A+, A-, B+, B-, AB+, AB-, O+, O-)",
    "alergias": "text",
    "medicamentos_uso_continuo": "text",
    "restricoes_medicas": "text",
    "contato_emergencia": {
      "nome": "string",
      "parentesco": "string",
      "telefone": "string"
    },
    "plano_saude": {
      "operadora": "string",
      "numero_carteira": "string",
      "validade": "date"
    }
  }
}
```

### **Preferências e Observações**
```json
{
  "preferencias": {
    "atividades_favoritas": ["string"],
    "horario_preferido": "enum (manha, tarde, noite, madrugada)",
    "dias_semana_preferidos": ["string"],
    "objetivos": ["string"],
    "nivel_experiencia": "enum (iniciante, intermediario, avancado)"
  },
  "observacoes": "text",
  "data_cadastro": "timestamp",
  "ultima_atualizacao": "timestamp",
  "status": "enum (ativo, inativo, suspenso, bloqueado)"
}
```

---

## 🏢 4. PESSOA JURÍDICA

### **Dados Empresariais**
```json
{
  "id": "uuid",
  "razao_social": "string (required)",
  "nome_fantasia": "string",
  "cnpj": "string (required, unique)",
  "inscricao_estadual": "string",
  "inscricao_municipal": "string",
  "cnae_principal": "string",
  "cnaes_secundarios": ["string"],
  "regime_tributario": "enum (simples, presumido, real, mei)",
  "porte_empresa": "enum (mei, microempresa, pequena, media, grande)",
  "data_abertura": "date",
  "capital_social": "decimal",
  "natureza_juridica": "string",
  "situacao_receita": "enum (ativa, baixada, suspensa, inapta)"
}
```

### **Representantes Legais**
```json
{
  "representantes": [
    {
      "pessoa_fisica_id": "uuid",
      "tipo": "enum (socio, administrador, representante_legal)",
      "percentual_participacao": "decimal",
      "data_inicio": "date",
      "data_fim": "date",
      "poderes": ["string"],
      "ativo": "boolean"
    }
  ]
}
```

### **Dados Bancários**
```json
{
  "dados_bancarios": [
    {
      "banco": "string (required)",
      "agencia": "string (required)",
      "conta": "string (required)",
      "tipo_conta": "enum (corrente, poupanca)",
      "pix_chave": "string",
      "pix_tipo": "enum (cpf, cnpj, telefone, email, aleatoria)",
      "principal": "boolean"
    }
  ]
}
```

---

## 🤝 5. CLIENTES

### **Perfil do Cliente**
```json
{
  "id": "uuid",
  "pessoa_id": "uuid (foreign_key)",
  "codigo_cliente": "string (required, unique)",
  "tipo_cliente": "enum (pessoa_fisica, pessoa_juridica)",
  "categoria": "enum (bronze, prata, ouro, premium, vip)",
  "score_engajamento": "integer (0-1000)",
  "data_primeiro_contato": "date",
  "data_primeira_compra": "date",
  "origem_cadastro": "enum (presencial, online, indicacao, marketing)",
  "vendedor_responsavel_id": "uuid",
  "filial_preferencial_id": "uuid"
}
```

### **Histórico de Relacionamento**
```json
{
  "historico": [
    {
      "data": "timestamp",
      "tipo": "enum (contato, visita, compra, reclamacao, elogio)",
      "descricao": "text",
      "usuario_id": "uuid",
      "valor": "decimal",
      "status": "enum (pendente, resolvido, cancelado)"
    }
  ]
}
```

### **Programa de Fidelidade**
```json
{
  "fidelidade": {
    "pontos_acumulados": "integer",
    "pontos_utilizados": "integer",
    "nivel_fidelidade": "enum (bronze, prata, ouro, diamante)",
    "data_ultimo_resgate": "date",
    "cashback_disponivel": "decimal",
    "indicacoes_realizadas": "integer",
    "bonus_indicacao": "decimal"
  }
}
```

### **Preferências de Comunicação**
```json
{
  "comunicacao": {
    "aceita_email_promocional": "boolean",
    "aceita_sms_promocional": "boolean",
    "aceita_whatsapp_promocional": "boolean",
    "aceita_ligacao_comercial": "boolean",
    "horario_preferido_contato": "enum (manha, tarde, noite)",
    "dias_preferidos_contato": ["string"],
    "idioma_preferido": "string"
  }
}
```

---

## 🚚 6. FORNECEDORES

### **Dados do Fornecedor**
```json
{
  "id": "uuid",
  "pessoa_id": "uuid (foreign_key)",
  "codigo_fornecedor": "string (required, unique)",
  "tipo_fornecedor": "enum (pessoa_fisica, pessoa_juridica)",
  "categoria": "enum (produto, servico, produto_servico)",
  "especialidades": ["string"],
  "porte": "enum (micro, pequeno, medio, grande)",
  "tempo_mercado_anos": "integer",
  "data_primeiro_contrato": "date"
}
```

### **Avaliação e Performance**
```json
{
  "avaliacao": {
    "nota_qualidade": "decimal (1-5)",
    "nota_pontualidade": "decimal (1-5)",
    "nota_preco": "decimal (1-5)",
    "nota_atendimento": "decimal (1-5)",
    "nota_geral": "decimal (1-5)",
    "total_pedidos": "integer",
    "pedidos_entregues_prazo": "integer",
    "percentual_pontualidade": "decimal",
    "valor_total_comprado": "decimal",
    "ultima_compra": "date"
  }
}
```

### **Condições Comerciais**
```json
{
  "condicoes": {
    "prazo_pagamento_padrao": "integer (dias)",
    "forma_pagamento_preferida": "enum (boleto, transferencia, cartao, pix)",
    "desconto_prazo": "decimal",
    "limite_credito": "decimal",
    "prazo_entrega_padrao": "integer (dias)",
    "frete_por_conta": "enum (fornecedor, cliente, negociavel)",
    "valor_minimo_pedido": "decimal",
    "aceita_devolucao": "boolean",
    "prazo_devolucao_dias": "integer"
  }
}
```

### **Certificações e Documentos**
```json
{
  "certificacoes": [
    {
      "tipo": "string",
      "orgao_emissor": "string",
      "numero": "string",
      "data_emissao": "date",
      "data_vencimento": "date",
      "arquivo_url": "string",
      "status": "enum (valido, vencido, em_renovacao)"
    }
  ]
}
```

---

## 💼 7. VENDEDORES

### **Dados Profissionais**
```json
{
  "id": "uuid",
  "funcionario_id": "uuid (foreign_key)",
  "codigo_vendedor": "string (required, unique)",
  "tipo_vendedor": "enum (interno, externo, freelancer)",
  "nivel": "enum (junior, pleno, senior, master)",
  "especializacao": ["string"],
  "territorio": {
    "tipo": "enum (geografico, segmento, produtos)",
    "descricao": "text",
    "restricoes": "text"
  },
  "data_inicio": "date",
  "status": "enum (ativo, inativo, ferias, licenca)"
}
```

### **Metas e Performance**
```json
{
  "metas": {
    "meta_mensal_valor": "decimal",
    "meta_mensal_quantidade": "integer",
    "meta_anual_valor": "decimal",
    "meta_anual_quantidade": "integer",
    "comissao_percentual": "decimal",
    "bonus_meta": "decimal",
    "vendas_mes_atual": "decimal",
    "vendas_ano_atual": "decimal",
    "percentual_meta_mensal": "decimal",
    "percentual_meta_anual": "decimal",
    "ranking_mensal": "integer",
    "ranking_anual": "integer"
  }
}
```

### **Clientes Atribuídos**
```json
{
  "clientes_atribuidos": [
    {
      "cliente_id": "uuid",
      "data_atribuicao": "date",
      "tipo_atribuicao": "enum (prospeccao, relacionamento, pos_venda)",
      "status": "enum (ativo, transferido, perdido)",
      "observacoes": "text"
    }
  ]
}
```

### **Treinamentos e Certificações**
```json
{
  "capacitacao": [
    {
      "tipo": "enum (treinamento, certificacao, workshop)",
      "nome": "string",
      "instituicao": "string",
      "data_inicio": "date",
      "data_conclusao": "date",
      "carga_horaria": "integer",
      "nota": "decimal",
      "certificado_url": "string",
      "status": "enum (concluido, em_andamento, cancelado)"
    }
  ]
}
```

---

## 👨‍💼 8. FUNCIONÁRIOS

### **Dados Trabalhistas**
```json
{
  "id": "uuid",
  "pessoa_fisica_id": "uuid (foreign_key)",
  "matricula": "string (required, unique)",
  "cargo_id": "uuid (foreign_key)",
  "departamento_id": "uuid (foreign_key)",
  "filial_id": "uuid (foreign_key)",
  "data_admissao": "date (required)",
  "data_demissao": "date",
  "tipo_contrato": "enum (clt, pj, estagiario, terceirizado)",
  "jornada_trabalho": "enum (integral, meio_periodo, flexivel)",
  "salario_base": "decimal",
  "status": "enum (ativo, inativo, ferias, licenca, afastado)"
}
```

### **Documentos Trabalhistas**
```json
{
  "documentos_trabalhistas": {
    "ctps": {
      "numero": "string",
      "serie": "string",
      "data_emissao": "date"
    },
    "pis_pasep": "string",
    "titulo_eleitor": {
      "numero": "string",
      "zona": "string",
      "secao": "string"
    },
    "certificado_reservista": "string",
    "carteira_vacinacao": "boolean",
    "exames_admissionais": {
      "data_ultimo_exame": "date",
      "resultado": "enum (apto, inapto, apto_com_restricoes)",
      "observacoes": "text"
    }
  }
}
```

### **Hierarquia e Permissões**
```json
{
  "hierarquia": {
    "supervisor_id": "uuid",
    "subordinados_ids": ["uuid"],
    "nivel_hierarquico": "integer",
    "perfil_sistema_id": "uuid",
    "permissoes_especiais": ["string"],
    "acesso_filiais": ["uuid"]
  }
}
```

### **Controle de Ponto**
```json
{
  "ponto": {
    "horario_entrada_padrao": "time",
    "horario_saida_padrao": "time",
    "tolerancia_atraso_minutos": "integer",
    "banco_horas_saldo": "integer (minutos)",
    "ferias_direito_dias": "integer",
    "ferias_usufruidas_dias": "integer",
    "faltas_justificadas": "integer",
    "faltas_injustificadas": "integer"
  }
}
```

### **Benefícios**
```json
{
  "beneficios": [
    {
      "tipo": "string",
      "valor": "decimal",
      "percentual_desconto": "decimal",
      "data_inicio": "date",
      "data_fim": "date",
      "ativo": "boolean",
      "observacoes": "text"
    }
  ]
}
```

---

## 🔧 9. PRESTADORES DE SERVIÇO

### **Dados Profissionais**
```json
{
  "id": "uuid",
  "pessoa_id": "uuid (foreign_key)",
  "codigo_prestador": "string (required, unique)",
  "tipo_prestador": "enum (pessoa_fisica, pessoa_juridica)",
  "categoria_servico": "enum (personal_trainer, nutricionista, fisioterapeuta, massoterapeuta, medico)",
  "especializacoes": ["string"],
  "tempo_experiencia_anos": "integer",
  "data_primeiro_contrato": "date",
  "status": "enum (ativo, inativo, suspenso)"
}
```

### **Certificações Profissionais**
```json
{
  "certificacoes": [
    {
      "tipo": "enum (graduacao, pos_graduacao, especializacao, certificacao)",
      "instituicao": "string",
      "curso": "string",
      "numero_registro": "string",
      "orgao_classe": "string",
      "data_conclusao": "date",
      "data_vencimento": "date",
      "documento_url": "string",
      "validado": "boolean"
    }
  ]
}
```

### **Agenda e Disponibilidade**
```json
{
  "agenda": {
    "horarios_disponiveis": {
      "segunda": [{"inicio": "time", "fim": "time"}],
      "terca": [{"inicio": "time", "fim": "time"}],
      "quarta": [{"inicio": "time", "fim": "time"}],
      "quinta": [{"inicio": "time", "fim": "time"}],
      "sexta": [{"inicio": "time", "fim": "time"}],
      "sabado": [{"inicio": "time", "fim": "time"}],
      "domingo": [{"inicio": "time", "fim": "time"}]
    },
    "duracao_sessao_padrao": "integer (minutos)",
    "intervalo_entre_sessoes": "integer (minutos)",
    "antecedencia_agendamento": "integer (horas)",
    "permite_reagendamento": "boolean",
    "permite_cancelamento": "boolean",
    "prazo_cancelamento_horas": "integer"
  }
}
```

### **Avaliações e Feedback**
```json
{
  "avaliacoes": {
    "nota_media": "decimal (1-5)",
    "total_avaliacoes": "integer",
    "total_atendimentos": "integer",
    "taxa_no_show": "decimal",
    "taxa_reagendamento": "decimal",
    "comentarios_recentes": [
      {
        "cliente_id": "uuid",
        "nota": "integer (1-5)",
        "comentario": "text",
        "data": "date",
        "anonimo": "boolean"
      }
    ]
  }
}
```

### **Condições Comerciais**
```json
{
  "comercial": {
    "valor_hora": "decimal",
    "valor_pacote_10_sessoes": "decimal",
    "valor_pacote_20_sessoes": "decimal",
    "percentual_comissao": "decimal",
    "forma_pagamento_preferida": "enum (pix, transferencia, dinheiro)",
    "aceita_plano_saude": "boolean",
    "planos_aceitos": ["string"],
    "politica_cancelamento": "text",
    "observacoes_comerciais": "text"
  }
}
```

---

## 💳 10. PLANOS E ASSINATURAS

### **Dados do Plano**
```json
{
  "id": "uuid",
  "codigo_plano": "string (required, unique)",
  "nome": "string (required)",
  "descricao": "text",
  "tipo": "enum (individual, corporativo, familia, estudante)",
  "categoria": "enum (basico, premium, vip, ilimitado)",
  "modalidades_incluidas": ["string"],
  "duracao_contrato_meses": "integer",
  "valor_mensal": "decimal (required)",
  "valor_matricula": "decimal",
  "valor_total_contrato": "decimal",
  "desconto_anual": "decimal",
  "ativo": "boolean"
}
```

### **Benefícios e Restrições**
```json
{
  "beneficios": {
    "check_ins_ilimitados": "boolean",
    "limite_check_ins_mes": "integer",
    "acesso_todas_filiais": "boolean",
    "filiais_permitidas": ["uuid"],
    "horarios_permitidos": {
      "inicio": "time",
      "fim": "time",
      "dias_semana": ["string"]
    },
    "convidados_por_mes": "integer",
    "desconto_servicos": "decimal",
    "avaliacao_fisica_inclusa": "boolean",
    "frequencia_avaliacao_meses": "integer",
    "personal_trainer_sessoes": "integer",
    "freeze_maximo_dias_ano": "integer"
  }
}
```

### **Condições de Pagamento**
```json
{
  "pagamento": {
    "formas_aceitas": ["string"],
    "desconto_anual": "decimal",
    "desconto_semestral": "decimal",
    "multa_cancelamento": "decimal",
    "carencia_cancelamento_meses": "integer",
    "tolerancia_atraso_dias": "integer",
    "juros_atraso_dia": "decimal",
    "multa_atraso": "decimal",
    "permite_parcelamento": "boolean",
    "max_parcelas": "integer"
  }
}
```

---

## 📊 RELACIONAMENTOS E CONSTRAINTS

### **Integridade Referencial**
```sql
-- Principais Foreign Keys
ALTER TABLE filiais 
ADD CONSTRAINT fk_filiais_empresa 
FOREIGN KEY (empresa_id) REFERENCES empresas(id);

ALTER TABLE funcionarios 
ADD CONSTRAINT fk_funcionarios_pessoa_fisica 
FOREIGN KEY (pessoa_fisica_id) REFERENCES pessoas_fisicas(id);

ALTER TABLE clientes 
ADD CONSTRAINT fk_clientes_pessoa 
FOREIGN KEY (pessoa_id) REFERENCES pessoas(id);

-- Índices para Performance
CREATE INDEX idx_cpf ON pessoas_fisicas(cpf);
CREATE INDEX idx_cnpj ON pessoas_juridicas(cnpj);
CREATE INDEX idx_email ON pessoas_fisicas(email_principal);
CREATE INDEX idx_telefone ON pessoas_fisicas(telefone_principal);
```

### **Validações**
```sql
-- Validações de CPF e CNPJ
ALTER TABLE pessoas_fisicas 
ADD CONSTRAINT chk_cpf_valido 
CHECK (LENGTH(cpf) = 11 AND cpf ~ '^[0-9]+$');

ALTER TABLE pessoas_juridicas 
ADD CONSTRAINT chk_cnpj_valido 
CHECK (LENGTH(cnpj) = 14 AND cnpj ~ '^[0-9]+$');

-- Validações de Email
ALTER TABLE pessoas_fisicas 
ADD CONSTRAINT chk_email_formato 
CHECK (email_principal ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
```

---

## 🔄 AUDITORIA E VERSIONAMENTO

### **Campos de Auditoria** (Todos os modelos)
```json
{
  "auditoria": {
    "created_at": "timestamp with time zone",
    "updated_at": "timestamp with time zone",
    "created_by": "uuid",
    "updated_by": "uuid",
    "version": "integer",
    "active": "boolean (default: true)",
    "metadata": "jsonb"
  }
}
```

### **Histórico de Alterações**
```json
{
  "historico_alteracoes": [
    {
      "data_alteracao": "timestamp",
      "usuario_id": "uuid",
      "campo_alterado": "string",
      "valor_anterior": "text",
      "valor_novo": "text",
      "motivo": "string",
      "ip_origem": "string"
    }
  ]
}
```

---

*📅 Última atualização: 02/10/2025*
*👨‍💻 Desenvolvido por: MiniMax Agent*