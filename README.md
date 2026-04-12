# 🚀 Modern Enterprise EKS Fargate Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-1.x-623CE4?logo=terraform)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.35-326CE5?logo=kubernetes)](https://kubernetes.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS_Fargate-FF9900?logo=amazonaws)](https://aws.amazon.com/eks/)

## 📝 Visão Geral do Projeto

Este repositório contém a implementação de uma arquitetura de **Kubernetes Serverless** de nível empresarial na AWS. O objetivo principal foi remover a sobrecarga operacional de gerenciar nós (EC2), utilizando o **Amazon EKS com Fargate**, garantindo uma infraestrutura altamente segura, escalável e otimizada para custos.

> **Destaque:** Este projeto não apenas provisiona recursos, mas resolve desafios reais de scheduler e compatibilidade de componentes nativos do Kubernetes em ambientes 100% Serverless.

---

## 🏗️ Arquitetura e Design de Rede

![Diagrama de Arquitetura](diagrama-arquitetura.png)

A arquitetura foi desenhada seguindo o framework de **Well-Architected** da AWS:

* **VPC Segura:** Subnets privadas isoladas para os workloads e subnets públicas apenas para gateways de saída.
* **EKS Fargate Profile:** Configurado para os namespaces `default` e `kube-system`, eliminando o gerenciamento de instâncias EC2 e patches de segurança no SO dos nós.
* **IAM Roles for Service Accounts (IRSA):** Implementação de OIDC Provider para associar permissões do IAM diretamente a Pods específicos, seguindo o princípio do menor privilégio.

---

## 🛠️ Tecnologias Utilizadas

* **IaC:** Terraform (Modularização e State Management).
* **Orquestração:** Amazon EKS (Versão 1.35).
* **Compute:** AWS Fargate (Serverless Kubernetes).
* **CLI Tools:** `kubectl`, `aws-cli`, `terraform`.

---

## 🚀 Implementação Passo a Passo

### 1. Provisionamento de Infraestrutura (IaC)
Utilizei o Terraform para garantir a idempotência do ambiente. O provisionamento incluiu a VPC, as rotas de rede e o Cluster Control Plane.
![Sucesso Terraform](screenshot-terraform-apply.png)

### 2. Governança e Acesso
Configuração do `kubeconfig` para administração segura e validação da saúde do cluster via console.
![Cluster Ativo](screenshot-eks-cluster.png)

### 3. Orquestração Serverless
Criação estratégica de perfis Fargate para garantir que o cluster nasça sem dependência de Data Planes clássicos.
![Fargate Profile](screenshot-fargate-profile.png)

---

## 🚧 Desafios Técnicos e Resiliência (Troubleshooting)

Um dos maiores diferenciais deste projeto foi a resolução do **"Gargalo do CoreDNS"**.

**Cenário:** O CoreDNS, por padrão, vem configurado para buscar instâncias EC2. Em um cluster 100% Fargate, isso resulta em Pods presos no status `Pending`.

**Resolução Técnica:**
Identifiquei a necessidade de realizar um patch no Deployment para injetar a anotação de scheduler do Fargate. Após testar diferentes abordagens (`kubectl edit` e `kubectl patch json`), optei pela estratégia de **Merge Patch**, que se mostrou a mais resiliente para automação:

```bash
kubectl patch deployment coredns -n kube-system --type merge -p '{"spec":{"template":{"metadata":{"annotations":{"[eks.amazonaws.com/compute-type](https://eks.amazonaws.com/compute-type)":"fargate"}}}}}'
