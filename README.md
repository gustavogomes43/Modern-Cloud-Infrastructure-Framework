# ☁️ Modern Enterprise Kubernetes Framework: EKS + Fargate (FinOps Edition)

Este repositório contém uma infraestrutura robusta, escalável e de baixo custo operacional, utilizando o conceito de **Infrastructure as Code (IaC)** com Terraform para provisionar um ambiente de containers totalmente gerenciado na AWS.

---

## 🛠️ Tecnologias e Decisões Técnicas

| Ferramenta | O que escolhi? | Benefício Técnico |
| :--- | :--- | :--- |
| **Terraform** | IaC (Infrastructure as Code) | Garante que o ambiente seja replicável e versionado. |
| **AWS EKS** | Orquestrador Kubernetes | Padrão de mercado para microserviços e alta disponibilidade. |
| **AWS Fargate** | Serverless Compute | **Redução de TCO**. Sem patches de SO e sem custo de ociosidade. |
| **VPC (Private Subnets)** | Segurança de Rede | Isolamento de recursos críticos contra acessos externos. |

---

## 💰 Benefícios Estratégicos & Redução de Custos

* **Zero-Idle Cost:** O Fargate escala do zero e cobra por segundo, eliminando gastos com servidores ligados sem uso.
* **Eficiência de Operação (ZeroOps):** Foco no negócio, não na manutenção de instâncias Linux.
* **Conformidade Fiscal:** Tags padronizadas via Terraform para auditoria total de custos.

---

## 💡 Desafios Técnicos e Resolução (Assessment de Engenharia)

Durante a construção, enfrentei desafios reais que simulam ambientes críticos:

### 1. O Desafio das Subnets e Ingress
**Problema:** O Kubernetes não conseguia criar Load Balancers automaticamente nas subnets privadas.
**Solução:** Identifiquei a falta de tags específicas. Implementei via Terraform a tag `kubernetes.io/role/internal-elb = 1`, permitindo a integração nativa entre K8s e a rede AWS.

### 2. Segurança e Princípio do Menor Privilégio
**Problema:** Como dar permissões aos Pods sem usar chaves de acesso estáticas?
**Solução:** Configurei as **IAM Roles for Service Accounts (IRSA)** com OIDC Provider, garantindo permissões temporárias e seguras.

### 3. Gestão de Repositórios e Instalação via CLI
**Problema:** O repositório oficial da HashiCorp apresentou erro de metadados (404) no Amazon Linux 2023.
**Solução:** Atuei de forma proativa instalando o binário do Terraform manualmente, garantindo a continuidade do deploy.

---
**Documentado por Gustavo Gomes** *Cloud Engineer focado em modernização, segurança e otimização de infraestrutura.*
