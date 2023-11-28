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
din egen. Så kan du bruke denne bøtten i kommandoen istedenfor: ```BUCKET_NAME=<ditt-bucket-name>```. 


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
* Her kan du begynne med å navigere til mappen infra og kjøre kommandoene terraform init,
terraform plan, og terraform apply. image og prefix verdien setter du til de som er definert i github actions terraform jobben.
* Dette vil opprette ett cloudwatch dashbord med ditt prefix navn. Du finner det oppe i aws cloudwatch, og dashboard.
* Dette dashbordet har to tabeller som holder telling ved hjelp av gauger på antall ansikter med, og antall ansikter uten maske. 
* Grunnen til dette er for det første og kontrollere med det blotte øyet at forventet resultat er korrekt, ettersom
dette er ny teknologi og her fikk jeg en mulighet teste påliteligheten. Dette er bilder jeg selv har tilgang til og ved å
utføre en slik test, kunne jeg selv se at grupperingen var korrekt. På denne måten fikk jeg kvalitetssikret at dataene i dashbordet var korrekt,
og at dette faktisk kan brukes som ett verktøy for å kontrollere antall PPE brudd, da i dette tilfellet på maskebruk.

## Oppgave 4B



# Oppgave 5. Drøfteoppgaver

## Det Første Prinsippet - Flyt

### A. Kontinuerlig Integrering

Forklar hva kontinuerlig integrasjon (CI) er og diskuter dens betydning i utviklingsprosessen. I ditt svar,
vennligst inkluder:

- En definisjon av kontinuerlig integrasjon.

Med det mener vi at vi bygger automatiske prosesser for å integrere kode til en felles kode fra flere bidragsgivere/utviklere, på en trygg måte
som sikrer at allerede fungerende kode ikke blir integrert med det nye, før visse kriterier er oppfylt.Dette skjer gjennom testing og bygging gjennom automatiske 
prosesser, som sikrer at feil blir oppdaget raskere av utviklere og bidrar til mer effektiv utvikling.

- Fordelene med å bruke CI i et utviklingsprosjekt - hvordan CI kan forbedre kodekvaliteten og effektivisere utviklingsprosessen.

At utviklerne forholder seg til ett felles test regime. Det er også tidsbesparende ettersom alle tester er standarisert og automatisert.
Får i tillegg også ett mer robust/større test regime, med tanke på at testomfanget er større, enn normalt utviklere alene
forholder seg til. Sparer tid ettersom bygging og testing er automatisert. Får også tydelig tilbakemelding fra disse prosessene.
Kan også jobbe i parallell med hver sin oppgave, og få kontinuerlig tilbakemelding om tilstanden til hele kodebasen/slutt produktet. I tillegg
så er det fordelaktig at denne prosessen fremmer små kontinuerlige endringer, som gjør det lettere å oppdage feil og endre tilbake til
det fungerende utgangspunktet.

- Hvordan jobber vi med CI i GitHub rent praktisk? For eskempel i et utviklingsteam på fire/fem utivklere?

Man lager en Github actions fil som definerer hva som skal skje ved f.eks en hendelse til en spesifikk branch. 
Her defineres alt av test og byggeprosesser, som skal sikre automatiske bygg og tester. Branch spesifikke oppgaver kan være f.eks kun bygg ved bruk av andre branches enn main. Man må også sikre hvilke roller de ulike bidragsyterne skal ha i dette miljøet. Dette kan man gjøre ved å definere roller og rettigheter i github. Alle 
utviklere forholder seg til denne actions filen. Viktig å ha hod sikring av main ved å f.eks kreve pull request ved ønske om integrering til denne branchen.
Utvidet testing ved f.eks pull request, for å sikre at endringen vil fungere i ett større system.

### B. Sammenligning av Scrum/Smidig og DevOps fra et Utviklers Perspektiv

I denne oppgaven skal du som utvikler reflektere over og sammenligne to sentrale metodikker i moderne
programvareutvikling: Scrum/Smidig og DevOps. Målet er å forstå hvordan valg av metodikk kan påvirke kvaliteten og
leveransetempoet i utvikling av programvare.

### Oppgave

1. **Scrum/Smidig Metodikk:**

- Beskriv kort, hovedtrekkene i Scrum metodikk og dens tilnærming til programvareutvikling.
- Diskuter eventuelle utfordringer og styrker ved å bruke Scrum/Smidig i programvareutviklingsprosjekter.

Scrum gjenkjennes hovedsaklig ved sin bruk av iterative prosesser kjent som sprints. I disse sprintene foregår
det prosesser som skal sikre at bitene av prosjektet kan rulle ut etterhvert som de blir klare til levering. 
Scrum kjennetegnes også av at man har oversikt over hvem som jobber med hva i en backlog, og hvilke oppgaver som er i fokus.
I disse sprintene har man også retrospectives som ofte fører til bedre forståelse av hvordan prosessen kan forbedres,
og på bakgrunn av tidsperspektivet mellom sprintene så vil det være kort vei fra retrospective, til neste iterasjon.
Utfordringer med scrum og da sprint metodikk er hvis det skulle forekomme endringsønsker hos produkteier, evt at 
det man holder på utvikle mister relevans underveis i prosessen. Dette kan resultere i at man må begynne helt på nytt.
En annen ulempe er at metodikken er sterkt avhengig av at man har folk i teamet som har god erfaring med det, for at 
det skal fungere som tenkt.

2. **DevOps Metodikk:**

- Forklar grunnleggende prinsipper og praksiser i DevOps, spesielt med tanke på integrasjonen av utvikling og drift.
- Analyser hvordan DevOps kan påvirke kvaliteten og leveransetempoet i programvareutvikling.
- Reflekter over styrker og utfordringer knyttet til bruk av DevOps i utviklingsprosjekter.

Mer autonome team, altså selvstyrte team. Integrering kontinuerlig av kode i utviklingsmiljø, gjennom som nevnt
automatiske prosesser for å sikre små kontinuerlig leveringer. Kan være problematisk med tanke på hvor ressurs
tungt det er å opprette disse automatiske pipelinene. Automatisering av infrastruktur som skal redusere manuelle
feil, og sikre gode muligheter for skalerbarhet. Det nyeste fenomenet som er kjent som infrastruktur som kode, som 
skal opprettholde versjon av systemer og endringer på en sikker måte, samtidig som man sikrer sin egen gjennoppbygging av infrastruktur
hvis det skulle forekomme fysiske skader f.eks på servere.

3. **Sammenligning og Kontrast:**

- Sammenlign Scrum/Smidig og DevOps i forhold til deres påvirkning på programvarekvalitet og leveransetempo.
- Diskuter hvilke aspekter ved hver metodikk som kan være mer fordelaktige i bestemte utviklingssituasjoner.

#### Forventninger til Besvarelsen

- Din analyse bør være balansert, kritisk og godt underbygget med eksempler eller teoretiske argumenter.
- Reflekter over egne erfaringer eller hypotetiske scenarier for å støtte dine argumenter og konklusjoner.

Scrum innebærer til å forholde seg til en prosess, gjentakende over en viss tid. Devops er ikke like 
styrt av tidsperspektiv, men er mer en serie med prosesser som gjentas syklisk i arbeidslivet. Hvor resultatet 
og ikke den tidsstyrte prosessen er i fokus.

Scrum kan være problematisk i forhold til viss det skulle skje endringer med produkteiers behov,
og relevans av produktutvikling. Dette kan resultere i at man må begynne helt på nytt.

Fordelen med scrum, er at det er mye mer tidsbasert, som gjør det lettere å forholde seg til
tidsfrister, og fokusere på de viktigste oppgavene innenfor denne tidsrammen. 

I devops er det mye mindre strukturerte prosesser enn i f.eks scrum, som kan resultere i 
feil fokus, og for høy tidsbruk. 

Fordelen med Dev ops, er at det er mye mer tilpasningsdyktig til endringer av behov, og 
relevans av f.eks ett produkt.

### C. Det Andre Prinsippet - Feedback

Tenk deg at du har implementert en ny funksjonalitet i en applikasjon du jobber med. Beskriv hvordan du vil
etablere og bruke teknikker vi har lært fra "feedback" for å sikre at den nye funksjonaliteten møter brukernes behov.
Behovene Drøft hvordan feedback bidrar til kontinuerlig forbedring og hvordan de kan integreres i ulike stadier av
utviklingslivssyklusen.

Svar:

Prinsippet feedback omhandler det å få direkte tilbakemelding på hvordan ny funksjonalitet oppfører seg, og at feedbacken påfaller den
som har innført den nye funksjonaliteten. Hensikten er at man skal kunne ta tak i problemer ved roten, slik at man unngår
tilbakefall fra midlertidige løsninger som har hopet seg opp. En måte å sikre at den nye 
funksjonaliteten møter kundenes behov kan være å overvåke funksjonaliteten i produksjon og logge aktiviteten.