# xat-lap-secure-infra

# Przykład założenia infrastruktury dla Logic Apps
Repo używa koncepcji devcontainers
jako sposobu na izolację środowiska od innych komponentów pracujących na hoście.
Do uruchomienia sugerowane jest posiadanie zainstalowanego środowiska kontereryzacji - Dockera. 

Uwaga, gdy pracujesz w kontenerze na linuksie, upewnij się, że w VSC masz ustawiony znak końca linii na styl linuxa (LF) a nie na windowsa (CRLF). 
Jeśli tego nie zrobisz, to skrypty będą błędnie interpretowane przez shell (bash)

Zawartość Repo
- katalog infra - zawiera skrypty (w bicep i az cli), które tworzą i konfigurują komponenety stacku azurowego

## Prezentowane koncepcje:
- zastosowanie skryptów automatyzujących tworzenie wymaganych komponentów w Azure - Bicep
- zestawienie bezpiecznej komunikacji przy użyciu prywatnych VNETów - temat często podkreślany przez klientów
    - Tworzenie Vnet, dzielenie na podsieci
    - tworzenie prywatnych endpointów we wskazanych podsieciach
    - ograniczenie dostępu do komunikacji z vnetów i prywatnych endpointów

## Żeby nie było za łatwo - topologia:
- Używane są cztery resource grupy - idealnie jeśli w testach każda będzie w innym regionie azurowym
- listę funkcjonalności dostępnych w regionach można znaleźć tu: https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies
- przeznaczenie grup:
    - FILES_RG_NAME
        - w tej grupie jest tworzony zasób Az File i to jest podstawowe przeznaczenie grupy. 
        - w celu zabezpieczenia ruchu przychodzącego mamy tu także endpointy prywatne i skojarzone z nimi NICi
    - WORKFLOW_RG_NAME
        - logic apka i komponenty wymagane przez logic apkę
        - VNet, do którego jest podpięty private endpoint (z grupy FILES_RG_NAME)
    - DATABUS_RG_NAME
        - szyna komunikatów, do której zapisuje "drugi" workfow. ("Pierwszy" generuje faktury i zapisuje je w FILES_RG_NAME)
    - ACCESS_RG_NAME
        - grupa do "testowania zabezpieczeń" do Az File, mamy ty maszynę VNET, NIC i wirtualną z linuxem. Z linuxa wygodnie jest zarządzać plikami (usuwać jakieś nadmiarowe, zakładać katalogi itd.).

# Aby odpalić:
## Zainstalować prerequisities:
- az cli
    - linux: 
        <code>curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash</code>
    - <code>az login --use-device-code</code>
    - list of az datacenters: 
        <code>az account list-locations -o table</code>
- bicep, aby zainstalować:
    - <code>az bicep install</code>
    - odpalić w shellu aby mieć stand-alone
    </br><code>
        curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64</br>
        chmod +x ./bicep</br>
        sudo mv ./bicep /usr/local/bin/bicep</br>
        bicep --version</br>
        bicep --help</br>
    </code>

## Inne
- utworzyć plik o nazwie ./infra/.env - można użyć jako template'u pliku przykładowego: ./infra/sample.env

## Co się dzieje po kolei
### Infrastruktura i zabezpieczenia
- Utworzenie komponentów podstawowywch zgodnie instrukcjami w main.bicep. Aby uruchomić: 
</br><code>cd ./infra/</br>sh ./build.sh</code>. </br>
W wyniku uruchomienia utworzą się
    - Resource Groups
    - w grupie ACCESS_RG_NAME: vnet ACCESS_VNET_NAME z podziałem podział na subnety (automatyzacja w modułach
</br><code>v-net.bicep, subnet.bicep</code>, wywoływanych z main.bicep). VNet jest wykorzystywany konfiguracji ACL w Az File, tzn. Az Flie odrzuci ruch nie pochodzący z tego VNetu (szczegóły niżej w tekście)
    - blob storage, a w nim zasobu az files, zgodnie z instrukcjami z pliku
    </br><code>az-files.bicep</code>
    - Maszyna wirtualna z Linuxem 
    - W grupie WORKFLOW_RG_NAME:
        - Private endpoint podczepiony do VNetu WORKFLOW_VNET_NAME. 
        - Referencja do tego endpointu z ACL ustawionych na storage account (do którego należy Az File) - to powoduje, że o ile ruch przechodzi przez przez private endpoint to jest wpuszczany do Az File.
    
### Sprawdzenie działania reguł dostępu
W celu sprawdzenia czy reguły ograniczenia dostępu do Az File działają w warstwie sieciowej (v-nets, private endpoints) wykonaj poniższe.

Po deploymencie sprawdzić, ze z Linuxa jest dostęp do Az Files. Aby sprawdzić dostęp do Az File z VM:
- zaloguj się do shella Linuxa, 
    - za wpuszczenie ruchu odpowiadają reguły firewalla zdefiniowane w NSG o nawie danej zmienną środowiskową LINUX_VM_NSG_NAME. Aby zobaczyć namiary na maszynę z linuxem, uruchom:
        - <code>sh ./linux-vm-show-conn-details.sh</code>
        - będziesz potrzebować jakiegoś edytora. Przy pierwszym logowaniu do linuxa wykonaj następujące polecenia:
            - <code>sudo apt update && sudo apt upgrade -y</code>
            - zainstaluj jakiś edytor tekstu, np. vim: <code>sudo apt install vim</code>
- podmontuj zasób z Az File do lokalnego systemu plików. Skrypt to zamontowania zasobu Az File na Windows/ Linux/ MacOS można pobrać z Portal Azure. Wybierz file share > Connect > rodzaj OSa. Skopiuj skrypt i uruchom na maszynie testowej
    - będziemy testować nadawanie/usuwanie dostępów, skrypt skopiowany z Azure Portal możesz zapisaćw pliku np. w lokalizacji usera: np. <code>vim mount.sh</code> i potem <code>sh ./mount.sh</code>Wykonanie tego skryptu spowoduje, że zasób z AzFile będzie dostępny także po restarcie, bez konieczności ponownego uruchomienia. (Aby wejść w tryb edycji w VIM, po uruchomieniu programu naciśnij a. Gdy skończysz edycję pliku, naciścij kombinację: Esc + : + w + q - czyli Write and Quit. Więcej o edytowaniu w VIM np tu: https://vim.rtorr.com/)
- Załóż plik, wyedytuj, zapisz
        - sprawdź, że pliki są widoczne z portalu Az w inspekcji zawartości udostępninych zasobów

- Po tym jak udało się skomunikować z Az File z komputera pracującego w innym regionie geograficznym, zabezpieczmy ruch. Celem poniższych kroków jest aby Az File akceptował komunikację z jawnie wskazanych podsieci należących do sieci prywatnej (private vnet). W prezentowanym przykładzie komunikacja zostanie zabezpieczona z użyciem reguł ustaionych, tzn. będzie szła po prywantym VNet - czyli service endpoints (https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview)
    - Rozpoczynamy od zamknięcia całego ruchu do Az File, który przychodzi po internecie publicznym. Poniższy skrypt uruchamia polecenia Az Cli, które wyłączają dostęp domyślny: 
    </br><code>sh ./az-file-deny-access.sh</code>
    </br>Po uruchomieniu tego skryptu, możesz sprawdzić, że dostęp do Az File z testowej maszyny linuxowej został wyłączony. Zawartość nie jest dostępna.
    - Po zweryfikowaniu, że domyślny dostęp został wyłączony, konfigurujemy ACL (access control list), w której wskazujemy że ma zostać wpuszczony ruch z subnetu, z którym jest skojarzony NIC (Network Interface Card) maszyny wirtualnej z linuxem.</br>
    <code>sh ./az-file-acl-add-linux-subnet.sh</code></br>
    W wyniku uruchomienia skryptu maszyna z linuxem (a właściwie subnet, do którego jest podpięta) ponownie uzyskuje dostęp do zasobów Az File.

to solve error
-'Unable to evaluate template language function 'extensionResourceId':
- use: [resourceId('Microsoft.SQL/servers/databases', parameters('sqlServerName'), 'TestDB')]

-------

# To be done prior to session workshop 4:
include in bicep:
    - event grid topic: infra/src/tmp/eg_topic.json
    - ASB namespace: infra/src/tmp/asb-ns.json
    - ASB queues for external and internal invoices: infra/src/tmp/asb_queues.json

