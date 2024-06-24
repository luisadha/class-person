#!/data/data/com.termux/files/usr/bin/bash
# Fungsi untuk membuat "kelas" Person baru
# name: create-person.sh 
# version: v0.02
# status: [TESTING PASS]
# depend: yq, jq, sed, mush and grep
#
# Mohon gunakan mush 
#if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then  echo -e "warn: Wrong move, you should type \`bash ${BASH_SOURCE[0]}' not \`source ${BASH_SOURCE[@]}'." 1>&2;  return 1; fi

#if [[ ! $- =~ i ]]; then  echo -e "warn: Wrong move, you should type \`bash ${0}' not \`source ${0}'." 1>&2;  exit 1; fi
CUSTOM_DIR="$HOME"
PROFILE="$HOME/@/@t.me/{{name}}/{{name}}_profile.yml"


#fi

Person() {
    local self=$1
    declare -gA "${self}"

    # Inisialisasi properti
    eval "${self}['name']=''"
    eval "${self}['username']=''"
    eval "${self}['age']=''"
    eval "${self}['hobbies']=''"
    eval "${self}['job']=''"

    # Metode untuk mengatur nama
    eval "
        function ${self}.setName {
            local name=\$1
            ${self}['name']=\$name
          }
    "

    # Metode untuk mengatur usia
    eval "
        function ${self}.setAge {
            local age=\$1
            ${self}['age']=\$age
        }
    "

    # Metode untuk mengatur username
    eval "
        function ${self}.setUsername {
            local username=\$1
            ${self}['username']=\$username
        }
    "

    # Metode untuk mengatur pekerjaan
    eval "
        function ${self}.setJob {
            local job=\$1
            ${self}['job']=\$job
        }
    "

    # Metode untuk mengatur hobi
    eval "
        function ${self}.setHobbies {
            local hobbies=\$@
            ${self}['hobbies']=\$hobbies
        }
    "

    # Metode untuk mendapatkan informasi
    eval "
        function ${self}.getInfo { 
        echo -e \"{'Name': \${${self}['name']}, 'Username': \${${self}['username']}, 'Age': \${${self}['age']}, 'Hobbies': \${${self}['hobbies']}, 'Job': \${${self}['job']}}\"
        }
    " 
}

# Contoh penggunaan kelas Person
function main()
{

# Membuat class person dari mushtache API
declare -A {{name}}
Person {{name}}

# Membuat Header YML
mkdir -p $HOME/@/@t.me/{{name}} # Edit ini jika memakai variable CUSTOM_DIR
touch $PROFILE
if ! grep -q 'PERSON:' $PROFILE; then
cat >> $PROFILE <<EOF
  PERSON:
EOF
fi

# Ambil data dari yml file
NAME=$(yq eval ".NAME" $PROFILE)
AGE=$(yq eval ".AGE" $PROFILE)
USERNAME=$(yq eval ".USERNAME" $PROFILE)
HOBBIES=$(yq eval -o=j ".HOBBIES" $PROFILE)
JOB=$(yq eval ".JOB" $PROFILE)

{{name}}.setName "\"${NAME:-null}\""
{{name}}.setAge "\"${AGE:-null}\""
{{name}}.setUsername "\"${USERNAME:-null}\""
{{name}}.setHobbies "${HOBBIES:-null}"
{{name}}.setJob "\"${JOB:-null}\""

local IS_AUTHOR={{name}}
# Menampilkan informasi
#

echo -e "JSON FORMAT OUTPUT: \n "
{{name}}.getInfo | sed "s/'/\"/g" | jq .

#[[ $CODE_NF -eq 404 ]] && echo 404
#read a < <(echo $(curl -X GET "https://api.gravatar.com/v3/profiles/${profileIdentifier}" -H "Authorization: Bearer ${TOKEN}" -s | jq . | jq '.profile_url' ));
read IS_GRAVATAR_USER < <(echo $(curl -X GET "https://api.gravatar.com/v3/profiles/${profileIdentifier}" -H "Authorization: Bearer ${TOKEN}" -s | jq ".profile_url" | grep -o "luisadha"))

if [ "$IS_AUTHOR" == "$IS_GRAVATAR_USER" ]; then

curl -X GET "https://api.gravatar.com/v3/profiles/${profileIdentifier}" -H "Authorization: Bearer ${TOKEN}" -s | jq . 
fi


  #fi
#echo -e "\nARRAY FORMAT:\n " && declare -A | grep "{{name}}" 
  return 0
}


if $(cat ${0} | grep -q "{{name}}"); then
  echo -e "ERR: Please set up variable first with mushtache!. Don't have it? you can install with \`bpkg install mush -g'"
  echo -e "\nUsage: \`eval \"\$(cat ./person.sh | name=<NEW CLASS PERSON VALUE> mush)\""
  echo -e "\t... | name=john_doe mush"
  echo -e " Read input from yml files and output will be convert into json format.\nCopyright (c) 2024 by Luis Adha <adharudin14@gmail.com>"
  exit 2
else
  main;
fi
