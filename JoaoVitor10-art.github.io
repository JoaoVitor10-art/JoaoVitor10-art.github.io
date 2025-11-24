
<!doctype html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Atividade 05 - Formulário</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; max-width:800px; margin:auto; }
        fieldset { border:1px solid #ccc; padding:16px; margin-bottom:12px; }
        label { display:block; margin-top:8px; }
        input[type="text"], input[type="email"], input[type="date"], input[type="tel"], select {
            width:100%; padding:8px; box-sizing:border-box; margin-top:4px;
        }
        .row { display:flex; gap:8px; }
        .col { flex:1; }
        .error { color:#b00020; font-size:0.9em; margin-top:4px; display:none; }
        .invalid { border:2px solid #b00020; }
        .success { background:#e6ffea; border:1px solid #34a853; color:#234d20; padding:10px; margin-top:12px; display:none; }
        .limit-note { font-size:0.9em; color:#444; margin-top:6px; }
        .actions { margin-top:12px; }
    </style>
</head>
<body>
    <h1>Formulário de Cadastro</h1>

    <form id="cadForm" novalidate>
        <fieldset>
            <legend>Dados Pessoais</legend>
            <div class="row">
                <div class="col">
                    <label for="nome">Nome *</label>
                    <input id="nome" name="nome" type="text" />
                    <div class="error" id="err-nome">Informe o nome.</div>
                </div>
                <div class="col">
                    <label for="sobrenome">Sobrenome *</label>
                    <input id="sobrenome" name="sobrenome" type="text" />
                    <div class="error" id="err-sobrenome">Informe o sobrenome.</div>
                </div>
            </div>

            <label for="email">E-mail *</label>
            <input id="email" name="email" type="email" />
            <div class="error" id="err-email">E-mail inválido (deve conter '@' e '.').</div>

            <div class="row">
                <div class="col">
                    <label for="nascimento">Nascimento *</label>
                    <input id="nascimento" name="nascimento" type="date" />
                    <div class="error" id="err-nascimento">Data de nascimento inválida.</div>
                </div>
                <div class="col">
                    <label for="ddd">DDD (somente número) *</label>
                    <input id="ddd" name="ddd" type="text" placeholder="Ex: 11" maxlength="2" />
                    <div class="error" id="err-ddd">DDD inválido.</div>
                </div>
            </div>

            <label for="telefone">Telefone (sem DDD) *</label>
            <input id="telefone" name="telefone" type="tel" placeholder="Ex: 912345678" />
            <div class="error" id="err-telefone">Informe o telefone.</div>
        </fieldset>

        <fieldset>
            <legend>Atividades Extracurriculares *(máx. 3)</legend>
            <label><input type="checkbox" name="extrac[]" value="Esportes" class="extrac" /> Esportes</label>
            <label><input type="checkbox" name="extrac[]" value="Música" class="extrac" /> Música</label>
            <label><input type="checkbox" name="extrac[]" value="Teatro" class="extrac" /> Teatro</label>
            <label><input type="checkbox" name="extrac[]" value="Voluntariado" class="extrac" /> Voluntariado</label>
            <label><input type="checkbox" name="extrac[]" value="Programação" class="extrac" /> Programação</label>
            <label><input type="checkbox" name="extrac[]" value="Artes" class="extrac" /> Artes</label>
            <div class="limit-note">Selecione até 3 atividades.</div>
            <div class="error" id="err-extrac">Selecione entre 1 e 3 atividades.</div>
        </fieldset>

        <fieldset>
            <legend>Opções</legend>
            <label><input type="checkbox" id="newsletter" name="newsletter" /> Desejo receber novidades por e-mail (opcional)</label>
        </fieldset>

        <div class="actions">
            <button type="submit">Enviar Formulário</button>
            <button type="reset" id="bt-reset" style="margin-left:8px;">Limpar</button>
        </div>

        <div class="success" id="successMsg">Cadastro realizado com sucesso!</div>
    </form>

    <script>
        // Lista de DDDs válidos do Brasil
        const BRAZIL_DDDS = [
            '11','12','13','14','15','16','17','18','19',
            '21','22','24','27','28',
            '31','32','33','34','35','37','38',
            '41','42','43','44','45','46',
            '47','48','49',
            '51','53','54','55',
            '61','62','63','64',
            '65','66','67','68','69',
            '71','73','74','75','77','79',
            '81','82','83','84','85','86','87','88','89',
            '91','92','93','94','95','96','97','98','99'
        ];

        const form = document.getElementById('cadForm');
        const fields = {
            nome: document.getElementById('nome'),
            sobrenome: document.getElementById('sobrenome'),
            email: document.getElementById('email'),
            nascimento: document.getElementById('nascimento'),
            ddd: document.getElementById('ddd'),
            telefone: document.getElementById('telefone'),
            extrac: Array.from(document.querySelectorAll('.extrac')),
            successMsg: document.getElementById('successMsg')
        };

        // Limita seleção de atividades a 3 (desabilita demais quando 3 marcadas)
        fields.extrac.forEach(chk => {
            chk.addEventListener('change', () => {
                const checked = fields.extrac.filter(c => c.checked).length;
                if (checked >= 3) {
                    fields.extrac.forEach(c => {
                        if (!c.checked) c.disabled = true;
                    });
                } else {
                    fields.extrac.forEach(c => c.disabled = false);
                }
                // hide error once user changes selection
                document.getElementById('err-extrac').style.display = checked > 0 && checked <= 3 ? 'none' : document.getElementById('err-extrac').style.display;
            });
        });

        form.addEventListener('submit', function (ev) {
            ev.preventDefault();
            clearErrors();
            let valid = true;

            // Required text fields
            if (!fields.nome.value.trim()) { markError('nome', 'err-nome'); valid = false; }
            if (!fields.sobrenome.value.trim()) { markError('sobrenome', 'err-sobrenome'); valid = false; }

            // Email basic validation: contains @ and . after @
            const emailVal = fields.email.value.trim();
            if (!emailVal || emailVal.indexOf('@') === -1 || emailVal.indexOf('.') === -1 || emailVal.lastIndexOf('.') < emailVal.indexOf('@')) {
                markError('email', 'err-email'); valid = false;
            }

            // Nascimento valida: data existente e menor que hoje e maior que 1900-01-01
            const nascVal = fields.nascimento.value;
            if (!isValidDate(nascVal)) {
                markError('nascimento', 'err-nascimento'); valid = false;
            } else {
                const d = new Date(nascVal);
                const today = new Date();
                if (d >= today || d.getFullYear() < 1900) {
                    markError('nascimento', 'err-nascimento'); valid = false;
                }
            }

            // DDD valida
            const dddVal = fields.ddd.value.trim();
            if (!/^\d{2}$/.test(dddVal) || BRAZIL_DDDS.indexOf(dddVal) === -1) {
                markError('ddd', 'err-ddd'); valid = false;
            }

            // Telefone obrigatório (simples)
            if (!fields.telefone.value.trim()) {
                markError('telefone', 'err-telefone'); valid = false;
            }

            // Extracurricular: deve ter entre 1 e 3 selecionadas (é campo obrigatório neste enunciado)
            const extracCount = fields.extrac.filter(c => c.checked).length;
            if (extracCount < 1 || extracCount > 3) {
                const el = document.getElementById('err-extrac');
                el.style.display = 'block';
                valid = false;
            }

            if (valid) {
                fields.successMsg.style.display = 'block';
                window.scrollTo({ top: 0, behavior: 'smooth' });
            } else {
                fields.successMsg.style.display = 'none';
                // move focus to first invalid field
                const firstInvalid = document.querySelector('.invalid');
                if (firstInvalid) firstInvalid.focus();
            }
        });

        function clearErrors() {
            fields.successMsg.style.display = 'none';
            document.querySelectorAll('.error').forEach(e => e.style.display = 'none');
            document.querySelectorAll('.invalid').forEach(i => i.classList.remove('invalid'));
        }

        function markError(fieldId, errId) {
            const f = document.getElementById(fieldId);
            const e = document.getElementById(errId);
            if (f) f.classList.add('invalid');
            if (e) e.style.display = 'block';
        }

        function isValidDate(str) {
            if (!str) return false;
            // YYYY-MM-DD expected from input[type=date]
            const parts = str.split('-');
            if (parts.length !== 3) return false;
            const y = parseInt(parts[0], 10);
            const m = parseInt(parts[1], 10) - 1;
            const d = parseInt(parts[2], 10);
            const dt = new Date(y, m, d);
            return dt.getFullYear() === y && dt.getMonth() === m && dt.getDate() === d;
        }

        // Limpa mensagens e habilita checkboxes ao resetar
        document.getElementById('bt-reset').addEventListener('click', () => {
            setTimeout(() => {
                clearErrors();
                fields.extrac.forEach(c => c.disabled = false);
            }, 0);
        });
    </script>
</body>
</html>
