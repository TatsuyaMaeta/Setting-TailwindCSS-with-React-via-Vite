#!/bin/bash

echo "新規作成するディレクトリ名を決めて下さい\\n
(そのままエンターの場合はデフォルトのフォルダ名になります)"
read createDir

# 入力がない場合にデフォルトのフォルダ名を割り当てる
if [$createDir = ""]; then
    createDir="react_tailwindcss_project"
fi

timeout=7
command="yarn create vite ${createDir} --template"
downKey="\033\[B"

filePath="${createDir}/src/"

expect -c "
    set timeout ${timeout}
    spawn yarn create vite ${createDir} --template
    expect \"Select a framework:\";
    send \"${downKey}${downKey}\\n\"
    expect \"Select a variant:\"
    send \"\\n\"
    interact
"
# 参考記事
# https://stackoverflow.com/questions/38736850/send-up-down-arrow-keys-to-process-through-pipe-in-linux-using-c-language
# https://sy-base.com/myrobotics/mac/expect_shell_script/


sleep 1
cd ${createDir}
yarn

sleep 1
# tailwindcssに関連するライブラリをインストール
yarn add -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# 親階層に戻る
cd ..

sleep 2
content="content\:\ \[\"\.\/index\.html\"\,\"\.\/src\/\*\*\/\*\.\{js\,ts\,jsx\,tsx\}\"\]"
mv ${createDir}/tailwind.config.cjs ${createDir}/tailwind2.config.cjs

sleep 2
sed -e "s/content\:\ \[\]/${content}/g" ${createDir}/tailwind2.config.cjs >${createDir}/tailwind.config.cjs

rm ${createDir}/tailwind2.config.cjs

code="@tailwind base;\\n@tailwind components;\\n@tailwind utilities;\\n"
indexcsspath="${createDir}/src/index.css"
rm ${indexcsspath}
echo ${code} >>${indexcsspath}

# ファイル名変更
mv ${filePath}App.jsx ${filePath}App4.jsx

appJsxtarget1="\<div className\=\"App\">"
appJsxContent1="\<div className\=\"text-7xl\"\>Hello React x Tailwindcss\!\!\<\/div\>\\n"
# Hello React x Tailwindcssを表示させる様に置換
sed -e "s/${appJsxtarget1}/${appJsxtarget1}${appJsxContent1}/g" ${filePath}App4.jsx >${filePath}App3.jsx
rm ${filePath}App4.jsx

# ViteとReactのアイコンを横並び及び中央寄せ
appJsxtarget2="\<div\>"
appJsxContent2="\<div className=\"flex justify-center\"\>\\n"
sed -e "s/${appJsxtarget2}/${appJsxContent2}/g" ${filePath}App3.jsx >${filePath}App2.jsx
# ファイル削除
rm ${filePath}App3.jsx

# クリックボタンを色をつけてhover時の色を追加
appJsxtarget3="\<button onClick\="
appJsxContent3="\<button className\=\"bg-blue-500 hover\:bg-blue-700 text-white font-bold py-2 px-4 rounded\" onClick\="
sed -e "s/${appJsxtarget3}/${appJsxContent3}/g" ${filePath}App2.jsx >${filePath}App.jsx
# ファイル削除
rm ${filePath}App2.jsx

# 作ったディレクトリに移動
cd ${createDir}
# ブラウザ起動
yarn dev

# sed コマンド
# https://tech-blog.rakus.co.jp/entry/20211022/sed

# 【mv】ファイル名を変更するコマンド
# https://uxmilk.jp/8334

# ボタンのCSS
# https://v1.tailwindcss.com/components/buttons

# linuxにおけるエスケープ処理
# https://www.javadrive.jp/start/num/index4.html
# https://xtech.nikkei.com/it/article/COLUMN/20060228/231046/