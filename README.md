# Eksamen PGR301 2023

## Sensor veiledning oppgave 1.A 

* Husk å opprette iam nøkler, og lagre disse trygt inne i github secrets.
* Lagre disse i github med samme navn som står inne i github actions filen oneA-deploy.yml
* DISSE SKAL IKKE SKRIVES INN I KLARTEKST noe sted i koden. 
* Gjør deg selv også en tjeneste og laste ned nøklene når du oppretter de i iam, 
du vil trenge tilgang til disse i klartekst til senere oppgaver.
* Nederst i oneA-deploy.yml er det viktig at du endrer stack name til noe personlig.
På linjen nedenfor ser du hvor du må skrive inn ditt stack navn: 
run: sam deploy --no-confirm-changeset --no-fail-on-empty-changeset --stack-name <her-skal-du-skrive-stacken-din> --s3-bucket pgr301-sam-bucket --capabilities CAPABILITY_IAM --region eu-west-1
* Deretter så må du navigere til template.yml inne i kjell mappen. Der det står bucket name med kandidat blabla, er det viktig at du bytter ut 
kandidat navnet med noe globalt unikt. Dette er ett krav til S3 bøtter.
* OBS OBS! Github actions filen kjører som en job, men det er en betingelse som sjekker hvilken branch det pushes til.
Basert på egne erfaringer med s3-bøtte komplikasjon ble ikke denne endret til to, men den vil kun bygge hvis 
det pushes til en annen branch enn main. Hvis main vil den både bygge og deploye.

## Sensor veiledning oppgave 1.B
* Naviger til mappen /kjell/hello_world og skriv inn kommandoene
```shell
docker build -t kjellpy . 
docker run -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=YYY -e BUCKET_NAME=kjellsimagebucket kjellpy
```
Hvis det skulle være noe trøbbel med kjellsimagebucket, kan du laste ned jpeg filene fra den bøtten, og uploade til 
din egen. Så kan du bruke denne bøtten i kommandoen istedenfor: BUCKET_NAME=<ditt-bucket-name>. 


## Oppgave 2A
* Prøv å kjøre mvn spring-boot:run for å teste 

* I rotmappen i repositoriet ligger det en Dockerfile. Start denne med kommandoen 
```shell
docker build -t ppe . 
docker run -p 8080:8080 -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=YYY -e BUCKET_NAME=kjellsimagebucket ppe
```
* Etter det kan du åpne en terminal og kjøre ```curl localhost:8080/scan-ppe?bucketName=<din bucket>```
Se om du ser innholdet i bøtten.

## Oppgave 2B

* Oppgaven omhandlet å lage en github actions workflow fil for å automatisere denne prosessen med å bygge og deploye
ett docker image til ecr repository, hvis det er push til main. Github actions filen som heter ecr-deploy.yml.

## Oppgave 3A
* I innfra mappen er allerede det meste av hardkodede verdier erstattet av en variabel som heter prefix. 
* Hva denne verdien er kan du selv velge øverst i den nevnte ecr-deploy.yml Der det står PREFIX: i terraform jobben.
* Inne i provider.tf mappen må du sette en unik verdi for din key. Endre det som står før / tegnet.

## Oppgave 3B
* Her er det litt endringer som må gjøres så vi tar det steg for steg.
* Se inne i ecr-deploy.yml, på jobben som heter build_and_push_too_registry. 
Her må du endre ecr repositoriet til ditt eget, ved docker tag og docker push. Om du ikke har eget kan du lage ett oppe i aws ui, ved å søke opp ecr. 
Erstatt alle stedene det står 2019-ecr-repo med ditt eget ecr repository.
* For å korrekt duplisere det som er blitt gjort må du endre på PREFIX: med f.eks ditt unike brukernavn, som beskrevet i tidligere steg.
Her må du også endre IMAGE i terraform jobben, til å vise til ditt ecr repository. Bare erstatt der det står 2019-ecr-repo, 
med ditt eget ecr repository. Men ikke endre på noe annet i IMAGE.

## Oppgave 4A 
*Her kan du begynne med å navigere til mappen infra og kjøre kommandoene terraform init,
terraform plan, og terraform apply. image og prefix verdien setter du til de som er definert i github actions terraform jobben.
* Dette vil opprette ett cloudwatch dashbord med ditt prefix navn. Du finner det oppe i aws cloudwatch, og dashboard.
* Dette dashbordet har to tabeller som holder telling ved hjelp av gauger på antall ansikter med, og antall ansikter uten maske. 
* Grunnen til dette er for det første og kontrollere med det blotte øyet at forventet resultat er korrekt, ettersom
dette er ny teknologi og her fikk jeg en mulighet teste påliteligheten. Dette er bilder jeg selv har tilgang til og ved å
utføre en slik test, kunne jeg selv se at grupperingen var korrekt. På denne måten fikk jeg kvalitetssikret at dataene i dashbordet var korrekt,
og at dette faktisk kan brukes som ett verktøy for å kontrollere antall PPE brudd, da i dette tilfellet på maskebruk.

## Oppgave 4B



## Oppgave 5 Drøfting