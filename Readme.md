<img src="assets/preview.jpg">

Кейс интеграции `статического` (SAST), `динамического` (DAST) и `интерактивного` (IAST) анализа в процессы безопасной разработки.

Стенд развёртывается через систему контейнеризации `Docker` и содержит следующие сервисы:

- `Gitea` (система контроля версий);
- `Jenkins` (система непрерывной интеграции, CI/CD);
- `Faraday` (система управления уязвимостями).

Для анализа уязвимых приложений в стенде используются:

- средства статического анализа: `Bandit`;
- средства динамического анализа: `OWASP ZAP`;
- разработанное средство интерактивного анализа (`Immunity IAST`).

## Содержание

<!-- TOC -->
  * [Содержание](#содержание)
  * [Развёртывание тестового стенда](#развёртывание-тестового-стенда)
  * [Первоначальная настройка Gitea](#первоначальная-настройка-gitea)
  * [Первоначальная настройка Jenkins](#первоначальная-настройка-jenkins)
  * [Первоначальная настройка Faraday](#первоначальная-настройка-faraday)
  * [Добавление анализируемых проектов](#добавление-анализируемых-проектов)
    * [Добавление репозитория в Gitea](#добавление-репозитория-в-gitea)
    * [Альтернативный способ: миграция репозитория](#альтернативный-способ-миграция-репозитория)
    * [Создание CI/CD-конвейера в Jenkins](#создание-cicd-конвейера-в-jenkins)
  * [Требования к git-репозиторию](#требования-к-репозиторию)
<!-- TOC -->

## Развёртывание тестового стенда

> [!IMPORTANT]
> Для запуска тестового стенда в вашей системе должны быть установлены `Docker`, `Docker Compose` и `Make`.

1. Добавьте в файл `hosts` следующее содержимое:

```
127.0.0.1 gitea.devops.local
127.0.0.1 jenkins.devops.local
127.0.0.1 faraday.devops.local
```

> [!TIP]
> Где находится файл hosts?
> 
> В Windows: `C:\Windows\System32\drivers\etc\hosts`
> 
> В Linux: `/etc/hosts`

2. Запустите тестовый стенд следующей командой:

```shell
make
```

> [!NOTE]
> Сервисы тестового стенда будут доступны по локальным доменным именам, указанным в файле `hosts`.

## Первоначальная настройка Gitea

1. Перейдите по адресу `gitea.devops.local`.

2. Установите настройки сервиса и нажмите кнопку `Install Gitea`.

<details>
<summary>👀 Как это выглядит?</summary>

<hr/>

![](assets/gitea_1.png)

![](assets/gitea_2.png)

<hr/>

</details>

3. Перейдите на вкладку `Register Account`, введите данные для административного аккаунта и нажмите кнопку `Register Account`:

<details>
<summary>👀 Пример</summary>

<hr/>

<img src="assets/gitea_3.png">

<hr/>

</details>

## Первоначальная настройка Jenkins

> [!NOTE]
> При развёртывании Jenkins автоматически создаются 3 пользователя:
> - Админ: `admin:admin`
> - Разработчик: `developer:developer`
> - Наблюдатель: `viewer:viewer`

1. Перейдите по адресу `jenkins.devops.local`.

2. Перейдите в `Manage Jenkins` -> `System` -> `Gitea Servers`.

<details>
<summary>👀 Где это?</summary>

<hr/>

![](assets/jenkins_2.png)

![](assets/jenkins_3.png)

<hr/>

</details>

3. Добавьте сервер:

<details>
<summary>👀 Как это выглядит?</summary>

<hr/>

<img src="assets/jenkins_4.png" />

<hr/>

</details>

4. Укажите название сервера и адрес `http://gitea:3000`.

<details>
<summary>👀 Пример</summary>

<hr/>

<img src="assets/jenkins_5.png" />

<hr/>

</details>

5. Создайте учётные данные для Gitea сервера (`Manage hooks` -> `Add`).

<details>
<summary>👀 Пример</summary>

<hr/>

![](assets/jenkins_6.png)

<hr/>

</details>

6. После этого нажмите кнопку `Save`.

<details>
<summary>👀 Где она?</summary>

<hr/>

На скриншоте ниже, внизу:

![](assets/jenkins_7.png)

<hr/>

</details>

## Первоначальная настройка Faraday

1. Для получения учётных данных для `Faraday` выполните следующую команду в терминале:

```shell
make creds
```

При повторных запусках стека приложений учётные данные могут теряться. В таком случае смените пароль пользователя `faraday` командой:

```shell
make change_creds
```

2. Перейдите и авторизуйтесь по адресу `faraday.devops.local`.

3. Добавьте секреты в `Jenkins` для авторизации в `Faraday` (`Manage Jenkins` -> `Credentials` -> `Add credentials`).

<details>
<summary>👀 Где это?</summary>

<hr/>

![](assets/jenkins_secret.png)

<hr/>

</details>

Выберите тип `Secret text` и добавьте 3 значения: `адрес сервиса`, `логин` и `пароль`.

<details>
<summary>👀 Пример</summary>

<hr/>

![](assets/secret_1.png)

![](assets/secret_2.png)

![](assets/secret_3.png)

<hr/>

</details>

> [!NOTE]
> Создаются именно секреты, чтобы учётные данные системы управления уязвимостей не попадали в логи сборок.

<details>
<summary>👀 Результат должен получиться таким</summary>

<hr/>

![](assets/jenkins_secret_1.png)

<hr/>

</details>

## Добавление анализируемых проектов

### Добавление репозитория в Gitea

1. Создайте репозизторий в `Gitea`.

<details>
<summary>👀 Куда жать?</summary>

<hr/>

![](assets/project_1.png)

<hr/>

</details>

2. Укажите данные для создания нового репозитория.

<details>
<summary>👀 Пример</summary>

<hr/>

![](assets/project_2.png)

<hr/>

</details>

Укажите данные для нового репозитория и нажмите кнопку `Create Repository`.

3. Следуйте командам на скриншоте для отправки локального `git`-репозитория в `Gitea`:

<details>
<summary>👀 Пример</summary>

<hr/>

![](assets/project_3.png)

<hr/>

</details>

### Альтернативный способ: миграция репозитория

Для примера мигрируем проект уязвимого Django-приложения [Vulnerable Polls](https://github.com/kaakaww/vuln_django_play).

1. При добавлении нового репозитория перейдите по ссылке `Migrate repository`:

<details>
<summary>👀 Где это?</summary>

<hr/>

![](assets/project_alt_1.png)

<hr/>

</details>

2. Выберите платформу, откуда нужно мигрировать репозиторий.

<details>
<summary>👀 Как это выглядит?</summary>

<hr/>

![](assets/project_alt_2.png)

<hr/>

</details>

3. Укажите адрес репозитория, его новое название и нажмите кнопку `Migrate Repository`.

<details>
<summary>👀 Пример</summary>

<hr/>

![](assets/project_alt_3.png)

<hr/>

</details>

### Создание CI/CD-конвейера в Jenkins

1. Нажмите `New Item` в левом меню:

<details>
<summary>👀 Где?</summary>

<hr/>

![](assets/pipe_1.png)

<hr/>

</details>

2. Укажите имя конвейера и выберите `Multibranch Pipeline`.

<details>
<summary>👀 Пример</summary>

<hr/>

![](assets/pipe_2.png)

<hr/>

</details>

3. Укажите настройки нового конвейера.

<details>
<summary>👀 Детали</summary>

<hr/>

![](assets/pipe_3.png)

Нажмите `Add source` в `Branch Sources`:

<div align="center">

![](assets/pipe_4.png)

</div>

Затем выберите учётные данные Gitea, созданные ранее. После этого в `Owner` укажите имя пользователя Gitea, затем выберите git-репозиторий:

<div align="center">

![](assets/pipe_5.png)

</div>

<hr/>

</details>

## Требования к git-репозиторию

Чтобы подключать проекты к тестовому стенду, git-репозитории следует привести к следующему виду:

1. `Jenkinsfile` в корне репозитория

<details>
<summary>👀 Пример содержимого файла</summary>

<hr/>

```groovy

```

<hr/>
</details>
