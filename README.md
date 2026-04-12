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

🎯 Conclusão e Mindset
Toda a infraestrutura foi validada e posteriormente destruída via terraform destroy, seguindo as melhores práticas de FinOps e controle rigoroso de recursos em nuvem.

"Do Terraform ao Running: Provisionando o futuro da computação serverless com precisão técnica e mentalidade Cloud Native."

---

Autor: Gustavo Gomes | Cloud Engineer & Devops



