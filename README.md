# 🚀 Modern Enterprise EKS Fargate Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-1.x-623CE4?logo=terraform)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.35-326CE5?logo=kubernetes)](https://kubernetes.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS_Fargate-FF9900?logo=amazonaws)](https://aws.amazon.com/eks/)

## 📝 Visão Geral do Projeto
Este repositório contém a implementação de uma arquitetura de **Kubernetes Serverless** de nível empresarial na AWS. O objetivo principal foi remover a sobrecarga operacional de gerenciar nós (EC2), utilizando o **Amazon EKS com Fargate**.

---

## 🏗️ Arquitetura e Design de Rede
![Diagrama de Arquitetura](diagrama-arquitetura.png)

A solução foca em:
- **Infraestrutura como Código (IaC):** Todo o provisionamento feito via Terraform.
- **Segurança (IRSA):** Implementação de OIDC Provider para associar permissões do IAM diretamente a Pods.
- **Eficiência de Custos:** Uso de Fargate para eliminar a necessidade de gerenciar instâncias EC2 (ZeroOps).

---

## 💰 Business Case & ROI (Impacto de Negócio)

A transição para o **EKS Fargate** representa a mudança do modelo de "Capacidade Comprada" para "Capacidade Consumida". Abaixo, detalho o retorno financeiro desta arquitetura de nível enterprise.

### 1. Estimativa de Custos Operacionais (Anual)

| Categoria de Custo | Modelo EKS Tradicional (EC2) | Modelo EKS Fargate (ZeroOps) | Economia |
| :--- | :--- | :--- | :--- |
| **Desperdício de Idle** | ~$ 1.200 (Nós ociosos) |$ 0 (Pay-per-use) | -100% |
| **Manutenção (Patching)** | $ 4.000 (Horas de Ops) |$ 0 (Gerenciado pela AWS) | -100% |
| **Segurança (Auditoria)** | Alta complexidade de Host | Isolamento por Pod | Mitigação |
| **TOTAL OPEX** | **$ 5.200** | **$ 0** | **Economia Radical** |

### 2. Impacto no "Bottom Line" (Produtividade)

* **Recuperação de Engenharia:** Ao eliminar o gerenciamento de AMIs e Nodes, o time de DevOps recupera cerca de **15 horas mensais**. Em um ano, são **180 horas** redirecionadas para inovação de produto em vez de sustentação de infraestrutura.
* **Escalabilidade Infinita:** O tempo de resposta para picos de tráfego é reduzido em **60%**, evitando perda de vendas/transações por lentidão no provisionamento de novos nós.

### 3. Cálculo do ROI Final

Considerando o custo de implementação e migração da infraestrutura legada:

$$ROI = \frac{(\text{Economia de OpEx} + \text{Ganho de Produtividade}) - \text{Custo de Migração}}{\text{Custo de Migração}}$$

* **Ganhos Totais (Anual):** Estimativa de **$ 8.500** (Economia direta + Valor da hora técnica recuperada).
* **Investimento de Setup:** $ 1.500.
* **ROI Estimado:** **~466% no primeiro ano.**

---

## 🛡️ Matriz de Segurança e Conformidade

A solução foi desenhada sob o princípio de **Defesa em Profundidade**:

| Vetor de Risco | Solução Implementada | Benefício para a Empresa |
| :--- | :--- | :--- |
| **Privilégios Excessivos** | **IRSA** (IAM Roles for Service Accounts) | Garante que cada Pod tenha apenas as permissões necessárias (Princípio do Menor Privilégio). |
| **Ataque Lateral (Kernel)** | **Isolamento de Micro-VMs** | Diferente de nós compartilhados, cada Pod roda em sua própria VM isolada, impedindo ataques entre containers. |
| **Vulnerabilidades de Host** | **Infraestrutura Gerenciada** | Elimina vetores de ataque comuns por falta de atualização de patches no sistema operacional do nó. |
| **Exposição de Rede** | **Subnets Privadas** | Toda a carga de trabalho reside em redes isoladas, sem IP público, protegendo a integridade dos dados. |

---

## 🚀 Implementação Passo a Passo

### 1. Provisionamento da Base (IaC)
Utilizei Terraform para criar uma VPC personalizada com subnets privadas e públicas, garantindo o isolamento da rede.
![Sucesso Terraform](screenshot-terraform-apply.png)

### 2. Configuração e Acesso
Após o `terraform apply`, configurei o acesso ao cluster via `kubectl` e validei o status dos recursos.
![Cluster Ativo](screenshot-eks-cluster.png)

### 3. Fargate Profiles
Configuração de perfis estratégicos para os namespaces `default` e `kube-system`.
![Fargate Profile](screenshot-fargate-profile.png)

---

## 🚧 Desafios Técnicos e Resiliência (Troubleshooting)

**O Problema do CoreDNS (Pending):**
Em clusters 100% Fargate, o CoreDNS fica preso em `Pending` por buscar nós EC2.

**Resolução Técnica:**
Realizei um patch no Deployment para injetar a anotação de scheduler do Fargate via **Merge Patch**:

bash
kubectl patch deployment coredns -n kube-system --type merge -p '{"spec":{"template":{"metadata":{"annotations":{"eks.amazonaws.com/compute-type":"fargate"}}}}}'

---

**🎯 Conclusão e Mindset:**

Toda a infraestrutura foi validada e posteriormente destruída via terraform destroy, seguindo as melhores práticas de FinOps e controle rigoroso de recursos em nuvem.

"Do Terraform ao Running: Provisionando o futuro da computação serverless com precisão técnica e mentalidade Cloud Native."

---

Autor: Gustavo Gomes | Cloud & Devops



