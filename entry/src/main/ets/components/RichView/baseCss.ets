export const baseCss = `
.vditor-reset {
    color: rgb(35 36 37);
    font-variant-ligatures: no-common-ligatures;
    font-family: "Helvetica Neue","Luxi Sans","DejaVu Sans","Hiragino Sans GB","Microsoft Yahei",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Noto Color Emoji","Segoe UI Symbol","Android Emoji","EmojiSymbols";
    word-wrap: break-word;
    overflow: auto;
    line-height: 1.5;
    word-break: break-word;
    padding: 0 10px;
    font-size: 14px;
}

.vditor-reset--anchor {
    padding-left: 20px
}

.vditor-reset--error {
    color: rgb(210 63 49);
    font-size: 12px;
    display: block;
    line-height: 16px
}

ul ul ul {
    list-style-type: square
}

ul ul {
    list-style-type: circle
}

ul {
    list-style-type: disc
}

ul,ol {
    padding-left: 2em;
    margin-top: 0;
    margin-bottom: 1em;
}

li+li {
    margin-top: .25em
}

audio {
    max-width: 100%
}

audio:focus {
    outline: none
}

video {
    max-height: 90vh;
    max-width: 100%
}

img {
    max-width: 100%
}

img.emoji {
    cursor: auto;
    max-width: 1.5em;
    vertical-align: sub;
}

h1,h2,h3,h4,h5,h6 {
    margin-top: 1em;
    margin-bottom: 0.5em;
    font-weight: 600;
    line-height: 1.25;
}

h1::before,h2::before,h3::before,h4::before,h5::before,h6::before {
    content: "";
    display: inline-block;
    height: 0.8em;
    position: relative;
    top: 0.05em;
    margin-right: 5px;
    background-color: black;
    width: 5px;
}

h1:hover .vditor-anchor svg,h2:hover .vditor-anchor svg,h3:hover .vditor-anchor svg,h4:hover .vditor-anchor svg,h5:hover .vditor-anchor svg,h6:hover .vditor-anchor svg {
    visibility: visible
}

h1 {
    font-size: 1.75em
}

h2 {
    font-size: 1.55em
}

h3 {
    font-size: 1.38em
}

h4 {
    font-size: 1.25em
}

h5 {
    font-size: 1.13em
}

h6 {
    font-size: 1em
}

hr {
    height: 0.5rem;
    padding: 0;
    margin: 2em 0;
    background-color: rgb(234 236 239);
    border: 0
}

p {
    margin-top: 0;
    margin-bottom: 1em;
}

blockquote {
    padding: 0 1em;
    color: rgb(106 115 125);
    border-left: .25em solid rgb(234 236 239);
    margin: 0 0 1em 0
}

blockquote>:first-child {
    margin-top: 0
}

blockquote>:last-child {
    margin-bottom: 0
}

ins>iframe {
    border: 0
}

iframe {
    border: 1px solid rgb(209 213 218);
    max-width: 100%;
    box-sizing: border-box
}

iframe.iframe__video {
    min-width: 80%;
    min-height: 36vh
}

table {
    border-collapse: collapse;
    empty-cells: show;
    margin-bottom: 1em;
    overflow: auto;
    border-spacing: 0;
    display: block;
    word-break: keep-all;
    width: 100%
}

table tr {
    background-color: rgb(250 251 252);
    border-top: 1px solid rgb(198 203 209)
}

table td,table th {
    padding: 0.5em 1em;
    border: 1px solid rgb(223, 226, 229);
    word-break: normal;
    white-space: nowrap
}

table td:first-child::after,table th:first-child::after {
    content: "";
    display: inline-block;
    vertical-align: top;
    min-height: 2em;
}

table th {
    font-weight: 600
}

table tbody tr:nth-child(2n) {
    background-color: white;
}

code:not(.hljs):not(.highlight-chroma) {
    padding: .2em .4em;
    margin: 0;
    font-size: 85%;
    border-radius: 0.2em;
    font-family: mononoki,Consolas,"Liberation Mono",Menlo,Courier,monospace,"Apple Color Emoji","Segoe UI Emoji","Noto Color Emoji","Segoe UI Symbol","Android Emoji","EmojiSymbols";
    word-break: break-word;
    background-size: 20px 20px;
    white-space: pre-wrap
}

pre {
    margin: 1em 0
}

pre>code {
    margin: 0;
    font-size: 85%;
    padding: .5em;
    border-radius: 0.2em;
    display: block;
    overflow: auto;
    white-space: pre;
    font-family: mononoki,Consolas,"Liberation Mono",Menlo,Courier,monospace,"Apple Color Emoji","Segoe UI Emoji","Noto Color Emoji","Segoe UI Symbol","Android Emoji","EmojiSymbols";
    background-size: 2em 2em;
    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAA8AgMAAABHkjHhAAAACVBMVEWAgIBaWlo+Pj7rTFvWAAAAA3RSTlMHCAw+VhR4AAAA+klEQVQoz4WSMW7EQAhFPxKWNh2FCx+HkaZI6RRb5DYbyVfIJXLKDCFoMbaTKSw/8ZnPAPjaH2xgZcUNUDADD7D9LtDBCLZ45fbkvo/30K8yeI64pPwl6znd/3n/Oe93P3ho9qeh72btTFzqkz0rsJle8Zr81OLEwZ1dv/713uWqvu2pl+k0fy7MWtj9r/tN5q/02z89qa/L4Dc2LvM93kezPfXlME/O86EbY/V9GB9ePX8G1/6W+/9h1dq/HGfTfzT3j/xNo7522Bfnqe5jO/fvhVthlfk434v3iO9zG/UOphyPeinPl1J8Gtaa7xPTa/Dk+RIs4deMvwGvcGsmsCvJ0AAAAABJRU5ErkJggg==);
    word-break: initial;
    word-wrap: normal
}

pre:hover div.vditor-copy {
    display: block
}

.language-math,.language-echarts,.language-mindmap,.language-plantuml,.language-mermaid,.language-abc,.language-flowchart,.language-graphviz {
    margin-bottom: 1em
}

.language-math mjx-container:focus {
    outline: none;
    cursor: context-menu
}

.language-echarts,.language-mindmap {
    overflow: hidden;
    height: 30em;
}

.language-mermaid,.language-flowchart,.language-graphviz {
    text-align: center
}

.language-graphviz parsererror {
    overflow: auto
}

kbd {
    display: inline-block;
    padding: 0.1em 0.2em;
    line-height: 10px;
    color: rgb(36, 41, 46);
    vertical-align: middle;
    background-color: rgb(250, 251, 252);
    border: solid 1px rgb(209, 213, 218);
    border-radius: 0.1em;
    box-shadow: inset 0 -1px 0 rgb(209, 213, 218);
}

summary {
    cursor: pointer
}

summary:focus {
    outline: none
}

svg {
    height: auto;
    width: auto;
    stroke-width: initial
}

p:last-child,blockquote:last-child,pre:last-child,ul:last-child,ol:last-child,hr:last-child {
    margin-bottom: 0
}

input {
    font: inherit;
}
input[type="checkbox"] {
    width: 1em;
    height: 1em;
}

a {
    font: inherit;
}
`