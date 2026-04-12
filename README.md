# Modern Enterprise EKS Fargate Infrastructure 🚀

Este projeto demonstra a implementação de uma infraestrutura robusta, escalável e segura na AWS utilizando Terraform e Amazon EKS (Elastic Kubernetes Service) com perfis Fargate (Serverless).

## 🏗️ Arquitetura do Projeto
![Diagrama de Arquitetura](./img/diagrama-arquitetura.png)

A solução foca em:
- **Infraestrutura como Código (IaC):** Todo o provisionamento feito via Terraform.
- **Segurança:** Implementação de IRSA (IAM Roles for Service Accounts) para privilégio mínimo.
- **Eficiência de Custos:** Uso de Fargate para eliminar a necessidade de gerenciar instâncias EC2 (ZeroOps).

---

## 🛠️ Passo a Passo da Implementação

### 1. Provisionamento da Base
Utilizei Terraform para criar uma VPC personalizada com subnets privadas e públicas, garantindo o isolamento da rede. O cluster EKS foi configurado para utilizar Fargate como compute engine principal.
![Sucesso Terraform](./img/screenshot-terraform-apply.png)

### 2. Configuração do Cluster
Após o `terraform apply`, configurei o acesso ao cluster via `kubectl` e validei o status dos recursos diretamente no Console AWS.
![Cluster Ativo](./img/screenshot-eks-cluster.png)

### 3. Fargate Profiles
Configurei perfis do Fargate para os namespaces `default` e `kube-system`, permitindo que até os componentes críticos do Kubernetes rodassem sem servidores físicos.
![Fargate Profile](./img/screenshot-fargate-profile.png)

---

## 🚧 Dificuldades Encontradas e Soluções (Troubleshooting)

### O Problema do CoreDNS (Pending)
**Dificuldade:** Ao iniciar o cluster, os pods do `coredns` ficaram presos no status `Pending`. Isso ocorreu porque o EKS, por padrão, tenta agendar o CoreDNS em instâncias EC2, que não existiam nesta arquitetura 100% Serverless.

**Tentativas de Solução:**
- Tentei utilizar `kubectl patch` via JSON para remover a anotação de compute-type, mas houve conflito de sintaxe no terminal da EC2.
- Tentei a edição manual via `kubectl edit`, mas o editor `vi` apresentou problemas de permissão/salvamento no ambiente.

**A Solução Definitiva:**
Apliquei um `kubectl patch` utilizando a estratégia de **Merge**, que forçou a anotação `eks.amazonaws.com/compute-type: fargate` no deployment do CoreDNS.
```bash
kubectl patch deployment coredns -n kube-system --type merge -p '{"spec":{"template":{"metadata":{"annotations":{"[eks.amazonaws.com/compute-type](https://eks.amazonaws.com/compute-type)":"fargate"}}}}}'
