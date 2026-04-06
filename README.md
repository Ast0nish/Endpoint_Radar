🔎 Endpoint Radar – PowerShell

Desenvolvido por Vinícius Pimentel

Uma ferramenta em PowerShell com interface gráfica (GUI), criada para analisar, monitorar e gerenciar aplicações, processos e extensões de navegador em máquinas Windows, localmente ou remotamente. Desenvolvida para profissionais de TI, Helpdesk e Security Operations que precisam de uma visão rápida e confiável do ambiente de trabalho de usuários.

📌 Funcionalidades
✅ Listar aplicativos instalados na máquina
✅ Listar pastas do usuário (C:/, AppData Local e Roaming)
✅ Listar processos ativos e identificar caminhos suspeitos
✅ Verificar extensões do Google Chrome (permitidas ou proibidas)
✅ Execução local automática se a máquina for a mesma do analista
✅ Execução remota via PowerShell Remoting (WinRM), com suporte a credenciais
✅ Interface gráfica moderna, limpa e intuitiva
✅ Saídas coloridas e organizadas para melhor legibilidade
✅ Alertas de erros e status em tempo real

🖥️ Interface
A interface foi pensada para ser simples e funcional, com:
Painel lateral com botões de ação
Painel principal para visualização das informações
Campos para informar Máquina e Usuário
Saída organizada em RichTextBox, com cores que destacam alertas
Botões interativos com hover e cursor em forma de mão

⚠️ Considerações sobre acesso remoto
Conexão remota requer WinRM habilitado e configuração de TrustedHosts.
Para uso doméstico ou lab, o script funciona 100% local, sem remoting.
Conexão por IP pode exigir permissões adicionais ou firewall liberado.
O script prioriza execução local quando detecta que a máquina é a mesma do analista.

🔐 Requisitos
Windows 10 / 11 ou Windows Server
PowerShell 5.1 ou superior
Permissão administrativa na máquina de origem
Acesso de rede à máquina de destino (se remoto)
WinRM habilitado para execução remota (opcional para uso local)

🚀 Como usar
Baixe ou clone o repositório:
git clone https://github.com/Ast0nish/Endpoint_Radar
Execute o script:
.\Endpoint_Radar.ps1
Informe:
Nome da máquina (ou deixe em branco para uso local)
Usuário (quando necessário, para AppData e Chrome)
Clique nos botões correspondentes para listar Apps, Processos, Pastas ou Extensões.

🧠 Observações técnicas
O script detecta automaticamente se a execução deve ser local ou remota.
Em ambientes corporativos, o WinRM pode exigir credenciais ou ajustes em TrustedHosts.
Alguns antivírus ou EDR podem bloquear execução de scripts ou acesso remoto.
Focado em uso interno e estudo, mas facilmente adaptável para ambientes corporativos.

📄 Licença
Uso interno / educacional.
Sinta-se à vontade para adaptar, melhorar e evoluir de acordo com o seu ambiente de estudo ou trabalho.

🤝 Contribuições
Sugestões, melhorias ou feedback são bem-vindos!
Abra uma issue ou envie um pull request para colaborar. 🚀
