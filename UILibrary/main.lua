--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    v1.6.53  |  2025-10-07  |  Roblox UI Library for scripts
    
    This script is NOT intended to be modified.
    To view the source code, see the `src/` folder on the official GitHub repository.
    
    Author: Footagesus (Footages, .ftgs, oftgs) (Edited by iHkazzz)
    Github: https://github.com/Footagesus/WindUI
    Discord: https://discord.gg/ftgs-development-hub-1300692552005189632
    License: MIT
]]


local a a={cache={}, load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}end return a.cache[b].c end}do function a.a()local b=game:GetService"RunService"local d=
b.Heartbeat
local e=game:GetService"UserInputService"
local f=game:GetService"TweenService"
local g=game:GetService"LocalizationService"
local h=game:GetService"HttpService"

local i="https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"

local j=loadstring(
game.HttpGetAsync and game:HttpGetAsync(i)
or h:GetAsync(i)
)()
j.SetIconsType"lucide"

local l

local m={
Font="rbxassetid://12187365364",
Localization=nil,
CanDraggable=true,
Theme=nil,
Themes=nil,
Icons=j,
Signals={},
Objects={},
LocalizationObjects={},
FontObjects={},
Language=string.match(g.SystemLocaleId,"^[a-z]+"),
Request=http_request or(syn and syn.request)or request,
DefaultProperties={
ScreenGui={
ResetOnSpawn=false,
ZIndexBehavior="Sibling",
},
CanvasGroup={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
Frame={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
TextLabel={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
RichText=true,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},TextButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
AutoButtonColor=false,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextBox={
BackgroundColor3=Color3.new(1,1,1),
BorderColor3=Color3.new(0,0,0),
ClearTextOnFocus=false,
Text="",
TextColor3=Color3.new(0,0,0),
TextSize=14,
},
ImageLabel={
BackgroundTransparency=1,
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
},
ImageButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
AutoButtonColor=false,
},
UIListLayout={
SortOrder="LayoutOrder",
},
ScrollingFrame={
ScrollBarImageTransparency=1,
BorderSizePixel=0,
},
VideoFrame={
BorderSizePixel=0,
}
},
Colors={
Red="#e53935",
Orange="#f57c00",
Green="#43a047",
Blue="#039be5",
White="#ffffff",
Grey="#484848",
},
}

function m.Init(p)
l=p
end

function m.AddSignal(p,r)
local u=p:Connect(r)
table.insert(m.Signals,u)
return u
end

function m.DisconnectAll()
for p,r in next,m.Signals do
local u=table.remove(m.Signals,p)
u:Disconnect()
end
end

function m.SafeCallback(p,...)
if not p then
return
end

local r,u=pcall(p,...)
if not r then
if l and l.Window and l.Window.Debug then local
v, x=u:find":%d+: "

warn("[ WindUI: DEBUG Mode ] "..u)

return l:Notify{
Title="DEBUG Mode: Error",
Content=not x and u or u:sub(x+1),
Duration=8,
}
end
end
end

function m.Gradient(p,r)
if l and l.Gradient then
return l:Gradient(p,r)
end

local u={}
local v={}

for x,z in next,p do
local A=tonumber(x)
if A then
A=math.clamp(A/100,0,1)
table.insert(u,ColorSequenceKeypoint.new(A,z.Color))
table.insert(v,NumberSequenceKeypoint.new(A,z.Transparency or 0))
end
end

table.sort(u,function(x,z)return x.Time<z.Time end)
table.sort(v,function(x,z)return x.Time<z.Time end)

if#u<2 then
error"ColorSequence requires at least 2 keypoints"
end

local x={
Color=ColorSequence.new(u),
Transparency=NumberSequence.new(v),
}

if r then
for z,A in pairs(r)do
x[z]=A
end
end

return x
end

function m.SetTheme(p)
m.Theme=p
m.UpdateTheme(nil,true)
end

function m.AddFontObject(p)
table.insert(m.FontObjects,p)
m.UpdateFont(m.Font)
end

function m.UpdateFont(p)
m.Font=p
for r,u in next,m.FontObjects do
u.FontFace=Font.new(p,u.FontFace.Weight,u.FontFace.Style)
end
end

function m.GetThemeProperty(p,r)
local u=r[p]or m.Themes.Dark[p]

if not u then return nil end

if type(u)=="string"and string.sub(u,1,1)=="#"then
return Color3.fromHex(u)
end

if typeof(u)=="Color3"then
return u
end

if type(u)=="table"and u.Color and u.Transparency then
return u
end

if type(u)=="function"then
return u()
end

return nil
end

function m.AddThemeObject(p,r)
m.Objects[p]={Object=p,Properties=r}
m.UpdateTheme(p,false)
return p
end

function m.AddLangObject(p)
local r=m.LocalizationObjects[p]
local u=r.Object
local v=currentObjTranslationId
m.UpdateLang(u,v)
return u
end

function m.UpdateTheme(p,r)
local function ApplyTheme(u)
for v,x in pairs(u.Properties or{})do
local z=m.GetThemeProperty(x,m.Theme)
if z then
if typeof(z)=="Color3"then
local A=u.Object:FindFirstChild"WindUIGradient"
if A then
A:Destroy()
end

if not r then
u.Object[v]=z
else
m.Tween(u.Object,0.08,{[v]=z}):Play()
end
elseif type(z)=="table"and z.Color and z.Transparency then
u.Object[v]=Color3.new(1,1,1)

local A=u.Object:FindFirstChild"WindUIGradient"
if not A then
A=Instance.new"UIGradient"
A.Name="WindUIGradient"
A.Parent=u.Object
end

A.Color=z.Color
A.Transparency=z.Transparency

for B,C in pairs(z)do
if B~="Color"and B~="Transparency"and A[B]~=nil then
A[B]=C
end
end
end
else
local A=u.Object:FindFirstChild"WindUIGradient"
if A then
A:Destroy()
end
end
end
end

if p then
local u=m.Objects[p]
if u then
ApplyTheme(u)
end
else
for u,v in pairs(m.Objects)do
ApplyTheme(v)
end
end
end

function m.SetLangForObject(p)
if m.Localization and m.Localization.Enabled then
local r=m.LocalizationObjects[p]
if not r then return end

local u=r.Object
local v=r.TranslationId

local x=m.Localization.Translations[m.Language]
if x and x[v]then
u.Text=x[v]
else
local z=m.Localization and m.Localization.Translations and m.Localization.Translations.en or nil
if z and z[v]then
u.Text=z[v]
else
u.Text="["..v.."]"
end
end
end
end

function m.ChangeTranslationKey(p,r,u)
if m.Localization and m.Localization.Enabled then
local v=string.match(u,"^"..m.Localization.Prefix.."(.+)")
if v then
for x,z in ipairs(m.LocalizationObjects)do
if z.Object==r then
z.TranslationId=v
m.SetLangForObject(x)
return
end
end

table.insert(m.LocalizationObjects,{
TranslationId=v,
Object=r
})
m.SetLangForObject(#m.LocalizationObjects)
end
end
end

function m.UpdateLang(p)
if p then
m.Language=p
end

for r=1,#m.LocalizationObjects do
local u=m.LocalizationObjects[r]
if u.Object and u.Object.Parent~=nil then
m.SetLangForObject(r)
else
m.LocalizationObjects[r]=nil
end
end
end

function m.SetLanguage(p)
m.Language=p
m.UpdateLang()
end

function m.Icon(p)
return j.Icon(p)
end

function m.AddIcons(p,r)
return j.AddIcons(p,r)
end

function m.New(p,r,u)
local v=Instance.new(p)

for x,z in next,m.DefaultProperties[p]or{}do
v[x]=z
end

for x,z in next,r or{}do
if x~="ThemeTag"then
v[x]=z
end
if m.Localization and m.Localization.Enabled and x=="Text"then
local A=string.match(z,"^"..m.Localization.Prefix.."(.+)")
if A then
local B=#m.LocalizationObjects+1
m.LocalizationObjects[B]={TranslationId=A,Object=v}

m.SetLangForObject(B)
end
end
end

for x,z in next,u or{}do
z.Parent=v
end

if r and r.ThemeTag then
m.AddThemeObject(v,r.ThemeTag)
end
if r and r.FontFace then
m.AddFontObject(v)
end
return v
end

function m.Tween(p,r,u,...)
return f:Create(p,TweenInfo.new(r,...),u)
end

function m.NewRoundFrame(p,r,u,v,x,z)
local function getImageForType(A)
return A=="Squircle"and"rbxassetid://80999662900595"
or A=="SquircleOutline"and"rbxassetid://117788349049947"
or A=="SquircleOutline2"and"rbxassetid://117817408534198"
or A=="Squircle-Outline"and"rbxassetid://117817408534198"
or A=="Shadow-sm"and"rbxassetid://84825982946844"
or A=="Squircle-TL-TR"and"rbxassetid://73569156276236"
or A=="Squircle-BL-BR"and"rbxassetid://93853842912264"
or A=="Squircle-TL-TR-Outline"and"rbxassetid://136702870075563"
or A=="Squircle-BL-BR-Outline"and"rbxassetid://75035847706564"
or A=="Square"and"rbxassetid://82909646051652"
or A=="Square-Outline"and"rbxassetid://72946211851948"
end

local function getSliceCenterForType(A)
return A~="Shadow-sm"and Rect.new(256
,256
,256
,256

)or Rect.new(512,512,512,512)
end

local A=m.New(x and"ImageButton"or"ImageLabel",{
Image=getImageForType(r),
ScaleType="Slice",
SliceCenter=getSliceCenterForType(r),
SliceScale=1,
BackgroundTransparency=1,
ThemeTag=u.ThemeTag and u.ThemeTag
},v)

for B,C in pairs(u or{})do
if B~="ThemeTag"then
A[B]=C
end
end

local function UpdateSliceScale(B)
local C=r~="Shadow-sm"and(B/(256))or(B/512)
A.SliceScale=math.max(C,0.0001)
end

local B={}

function B.SetRadius(C,F)
UpdateSliceScale(F)
end

function B.SetType(C,F)
r=F
A.Image=getImageForType(F)
A.SliceCenter=getSliceCenterForType(F)
UpdateSliceScale(p)
end

function B.UpdateShape(C,F,G)
if G then
r=G
A.Image=getImageForType(G)
A.SliceCenter=getSliceCenterForType(G)
end
if F then
p=F
end
UpdateSliceScale(p)
end

function B.GetRadius(C)
return p
end

function B.GetType(C)
return r
end

UpdateSliceScale(p)

return A,z and B or nil
end

local p=m.New local r=
m.Tween

function m.SetDraggable(u)
m.CanDraggable=u
end

function m.Drag(u,v,x)
local z
local A,B,C,F
local G={
CanDraggable=true
}

if not v or type(v)~="table"then
v={u}
end

local function update(H)
local J=H.Position-C
m.Tween(u,0.02,{Position=UDim2.new(
F.X.Scale,F.X.Offset+J.X,
F.Y.Scale,F.Y.Offset+J.Y
)}):Play()
end

for H,J in pairs(v)do
J.InputBegan:Connect(function(L)
if(L.UserInputType==Enum.UserInputType.MouseButton1 or L.UserInputType==Enum.UserInputType.Touch)and G.CanDraggable then
if z==nil then
z=J
A=true
C=L.Position
F=u.Position

if x and type(x)=="function"then
x(true,z)
end

L.Changed:Connect(function()
if L.UserInputState==Enum.UserInputState.End then
A=false
z=nil

if x and type(x)=="function"then
x(false,z)
end
end
end)
end
end
end)

J.InputChanged:Connect(function(L)
if z==J and A then
if L.UserInputType==Enum.UserInputType.MouseMovement or L.UserInputType==Enum.UserInputType.Touch then
B=L
end
end
end)
end

e.InputChanged:Connect(function(H)
if H==B and A and z~=nil then
if G.CanDraggable then
update(H)
end
end
end)

function G.Set(H,J)
G.CanDraggable=J
end

return G
end

j.Init(p,"Icon")

function m.Image(u,v,x,z,A,B,C)
local function SanitizeFilename(F)
F=F:gsub("[%s/\\:*?\"<>|]+","-")
F=F:gsub("[^%w%-_%.]","")
return F
end

z=z or"Temp"
v=SanitizeFilename(v)

local F=p("Frame",{
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
},{
p("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType="Crop",
ThemeTag=(m.Icon(u)or C)and{
ImageColor3=B and"Icon"or nil
}or nil,
},{
p("UICorner",{
CornerRadius=UDim.new(0,x)
})
})
})
if m.Icon(u)then
F.ImageLabel:Destroy()

local G=j.Image{
Icon=u,
Size=UDim2.new(1,0,1,0),
Colors={
(B and"Icon"or false),
"Button"
}
}.IconFrame
G.Parent=F
elseif string.find(u,"http")then
local G="WindUI/"..z.."/Assets/."..A.."-"..v..".png"
local H,J=pcall(function()
task.spawn(function()
if not isfile(G)then
local H=m.Request{
Url=u,
Method="GET",
}.Body

writefile(G,H)
end
F.ImageLabel.Image=getcustomasset(G)
end)
end)
if not H then
warn("[ WindUI.Creator ]  '"..identifyexecutor().."' doesnt support the URL Images. Error: "..J)

F:Destroy()
end
elseif u==""then
F.Visible=false
else
F.ImageLabel.Image=u
end

return F
end

return m end function a.b()
local b={}







function b.New(e,f,g)
local h={
Enabled=f.Enabled or false,
Translations=f.Translations or{},
Prefix=f.Prefix or"loc:",
DefaultLanguage=f.DefaultLanguage or"en"
}

g.Localization=h

return h
end



return b end function a.c()
local b=a.load'a'
local e=b.New
local f=b.Tween

local g={
Size=UDim2.new(0,300,1,-156),
SizeLower=UDim2.new(0,300,1,-56),
UICorner=13,
UIPadding=14,

Holder=nil,
NotificationIndex=0,
Notifications={}
}

function g.Init(h)
local i={
Lower=false
}

function i.SetLower(j)
i.Lower=j
i.Frame.Size=j and g.SizeLower or g.Size
end

i.Frame=e("Frame",{
Position=UDim2.new(1,-29,0,56),
AnchorPoint=Vector2.new(1,0),
Size=g.Size,
Parent=h,
BackgroundTransparency=1,




},{
e("UIListLayout",{
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
VerticalAlignment="Bottom",
Padding=UDim.new(0,8),
}),
e("UIPadding",{
PaddingBottom=UDim.new(0,29)
})
})
return i
end

function g.New(h)
local i={
Title=h.Title or"Notification",
Content=h.Content or nil,
Icon=h.Icon or nil,
IconThemed=h.IconThemed,
Background=h.Background,
BackgroundImageTransparency=h.BackgroundImageTransparency,
Duration=h.Duration or 5,
Buttons=h.Buttons or{},
CanClose=true,
UIElements={},
Closed=false,
}
if i.CanClose==nil then
i.CanClose=true
end
g.NotificationIndex=g.NotificationIndex+1
g.Notifications[g.NotificationIndex]=i









local j

if i.Icon then





















j=b.Image(
i.Icon,
i.Title..":"..i.Icon,
0,
h.Window,
"Notification",
i.IconThemed
)
j.Size=UDim2.new(0,26,0,26)
j.Position=UDim2.new(0,g.UIPadding,0,g.UIPadding)

end

local l
if i.CanClose then
l=e("ImageButton",{
Image=b.Icon"x"[1],
ImageRectSize=b.Icon"x"[2].ImageRectSize,
ImageRectOffset=b.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(1,-g.UIPadding,0,g.UIPadding),
AnchorPoint=Vector2.new(1,0),
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=.4,
},{
e("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})
end

local m=e("Frame",{
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=.95,
ThemeTag={
BackgroundColor3="Text",
},

})

local p=e("Frame",{
Size=UDim2.new(1,
i.Icon and-28-g.UIPadding or 0,
1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
AutomaticSize="Y",
},{
e("UIPadding",{
PaddingTop=UDim.new(0,g.UIPadding),
PaddingLeft=UDim.new(0,g.UIPadding),
PaddingRight=UDim.new(0,g.UIPadding),
PaddingBottom=UDim.new(0,g.UIPadding),
}),
e("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,-30-g.UIPadding,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextSize=16,
ThemeTag={
TextColor3="Text"
},
Text=i.Title,
FontFace=Font.new(b.Font,Enum.FontWeight.Medium)
}),
e("UIListLayout",{
Padding=UDim.new(0,g.UIPadding/3)
})
})

if i.Content then
e("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=15,
ThemeTag={
TextColor3="Text"
},
Text=i.Content,
FontFace=Font.new(b.Font,Enum.FontWeight.Medium),
Parent=p
})
end


local r=b.NewRoundFrame(g.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(2,0,1,0),
AnchorPoint=Vector2.new(0,1),
AutomaticSize="Y",
ImageTransparency=.05,
ThemeTag={
ImageColor3="Background"
},

},{
e("CanvasGroup",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
m,
e("UICorner",{
CornerRadius=UDim.new(0,g.UICorner),
})

}),
e("ImageLabel",{
Name="Background",
Image=i.Background,
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ScaleType="Crop",
ImageTransparency=i.BackgroundImageTransparency

},{
e("UICorner",{
CornerRadius=UDim.new(0,g.UICorner),
})
}),

p,
j,l,
})

local u=e("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Parent=h.Holder
},{
r
})

function i.Close(v)
if not i.Closed then
i.Closed=true
f(u,0.45,{Size=UDim2.new(1,0,0,-8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
f(r,0.55,{Position=UDim2.new(2,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.wait(.45)
u:Destroy()
end
end

task.spawn(function()
task.wait()
f(u,0.45,{Size=UDim2.new(
1,
0,
0,
r.AbsoluteSize.Y
)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
f(r,0.45,{Position=UDim2.new(0,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if i.Duration then
f(m,i.Duration,{Size=UDim2.new(1,0,1,0)},Enum.EasingStyle.Linear,Enum.EasingDirection.InOut):Play()
task.wait(i.Duration)
i:Close()
end
end)

if l then
b.AddSignal(l.TextButton.MouseButton1Click,function()
i:Close()
end)
end


return i
end

return g end function a.d()











local b=4294967296;local e=b-1;local function c(f,g)local h,i=0,1;while f~=0 or g~=0 do local j,l=f%2,g%2;local m=(j+l)%2;h=h+m*i;f=math.floor(f/2)g=math.floor(g/2)i=i*2 end;return h%b end;local function k(f,g,h,...)local i;if g then f=f%b;g=g%b;i=c(f,g)if h then i=k(i,h,...)end;return i elseif f then return f%b else return 0 end end;local function n(f,g,h,...)local i;if g then f=f%b;g=g%b;i=(f+g-c(f,g))/2;if h then i=n(i,h,...)end;return i elseif f then return f%b else return e end end;local function o(f)return e-f end;local function q(f,g)if g<0 then return lshift(f,-g)end;return math.floor(f%4294967296/2^g)end;local function s(f,g)if g>31 or g<-31 then return 0 end;return q(f%b,g)end;local function lshift(f,g)if g<0 then return s(f,-g)end;return f*2^g%4294967296 end;local function t(f,g)f=f%b;g=g%32;local h=n(f,2^g-1)return s(f,g)+lshift(h,32-g)end;local f={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(g)return string.gsub(g,".",function(h)return string.format("%02x",string.byte(h))end)end;local function y(g,h)local i=""for j=1,h do local l=g%256;i=string.char(l)..i;g=(g-l)/256 end;return i end;local function D(g,h)local i=0;for j=h,h+3 do i=i*256+string.byte(g,j)end;return i end;local function E(g,h)local i=64-(h+9)%64;h=y(8*h,8)g=g.."\128"..string.rep("\0",i)..h;assert(#g%64==0)return g end;local function I(g)g[1]=0x6a09e667;g[2]=0xbb67ae85;g[3]=0x3c6ef372;g[4]=0xa54ff53a;g[5]=0x510e527f;g[6]=0x9b05688c;g[7]=0x1f83d9ab;g[8]=0x5be0cd19;return g end;local function K(g,h,i)local j={}for l=1,16 do j[l]=D(g,h+(l-1)*4)end;for l=17,64 do local m=j[l-15]local p=k(t(m,7),t(m,18),s(m,3))m=j[l-2]j[l]=(j[l-16]+p+j[l-7]+k(t(m,17),t(m,19),s(m,10)))%b end;local l,m,p,r,u,v,x,z=i[1],i[2],i[3],i[4],i[5],i[6],i[7],i[8]for A=1,64 do local B=k(t(l,2),t(l,13),t(l,22))local C=k(n(l,m),n(l,p),n(m,p))local F=(B+C)%b;local G=k(t(u,6),t(u,11),t(u,25))local H=k(n(u,v),n(o(u),x))local J=(z+G+H+f[A]+j[A])%b;z=x;x=v;v=u;u=(r+J)%b;r=p;p=m;m=l;l=(J+F)%b end;i[1]=(i[1]+l)%b;i[2]=(i[2]+m)%b;i[3]=(i[3]+p)%b;i[4]=(i[4]+r)%b;i[5]=(i[5]+u)%b;i[6]=(i[6]+v)%b;i[7]=(i[7]+x)%b;i[8]=(i[8]+z)%b end;local function Z(g)g=E(g,#g)local h=I{}for i=1,#g,64 do K(g,i,h)end;return w(y(h[1],4)..y(h[2],4)..y(h[3],4)..y(h[4],4)..y(h[5],4)..y(h[6],4)..y(h[7],4)..y(h[8],4))end;local g;local h={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local i={["/"]="/"}for j,l in pairs(h)do i[l]=j end;local j=function(j)return"\\"..(h[j]or string.format("u%04x",j:byte()))end;local l=function(l)return"null"end;local m=function(m,p)local r={}p=p or{}if p[m]then error"circular reference"end;p[m]=true;if rawget(m,1)~=nil or next(m)==nil then local u=0;for v in pairs(m)do if type(v)~="number"then error"invalid table: mixed or invalid key types"end;u=u+1 end;if u~=#m then error"invalid table: sparse array"end;for v,x in ipairs(m)do table.insert(r,g(x,p))end;p[m]=nil;return"["..table.concat(r,",").."]"else for u,v in pairs(m)do if type(u)~="string"then error"invalid table: mixed or invalid key types"end;table.insert(r,g(u,p)..":"..g(v,p))end;p[m]=nil;return"{"..table.concat(r,",").."}"end end;local p=function(p)return'"'..p:gsub('[%z\1-\31\\"]',j)..'"'end;local r=function(r)if r~=r or r<=-math.huge or r>=math.huge then error("unexpected number value '"..tostring(r).."'")end;return string.format("%.14g",r)end;local u={["nil"]=l,table=m,string=p,number=r,boolean=tostring}g=function(v,x)local z=type(v)local A=u[z]if A then return A(v,x)end;error("unexpected type '"..z.."'")end;local v=function(v)return g(v)end;local x;local z=function(...)local z={}for A=1,select("#",...)do z[select(A,...)]=true end;return z end;local A=z(" ","\t","\r","\n")local B=z(" ","\t","\r","\n","]","}",",")local C=z("\\","/",'"',"b","f","n","r","t","u")local F=z("true","false","null")local G={["true"]=true,["false"]=false,null=nil}local H=function(H,J,L,M)for N=J,#H do if L[H:sub(N,N)]~=M then return N end end;return#H+1 end;local J=function(J,L,M)local N=1;local O=1;for P=1,L-1 do O=O+1;if J:sub(P,P)=="\n"then N=N+1;O=1 end end;error(string.format("%s at line %d col %d",M,N,O))end;local L=function(L)local M=math.floor;if L<=0x7f then return string.char(L)elseif L<=0x7ff then return string.char(M(L/64)+192,L%64+128)elseif L<=0xffff then return string.char(M(L/4096)+224,M(L%4096/64)+128,L%64+128)elseif L<=0x10ffff then return string.char(M(L/262144)+240,M(L%262144/4096)+128,M(L%4096/64)+128,L%64+128)end;error(string.format("invalid unicode codepoint '%x'",L))end;local M=function(M)local N=tonumber(M:sub(1,4),16)local O=tonumber(M:sub(7,10),16)if O then return L((N-0xd800)*0x400+O-0xdc00+0x10000)else return L(N)end end;local N=function(N,O)local P=""local Q=O+1;local R=Q;while Q<=#N do local S=N:byte(Q)if S<32 then J(N,Q,"control character in string")elseif S==92 then P=P..N:sub(R,Q-1)Q=Q+1;local T=N:sub(Q,Q)if T=="u"then local U=N:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",Q+1)or N:match("^%x%x%x%x",Q+1)or J(N,Q-1,"invalid unicode escape in string")P=P..M(U)Q=Q+#U else if not C[T]then J(N,Q-1,"invalid escape char '"..T.."' in string")end;P=P..i[T]end;R=Q+1 elseif S==34 then P=P..N:sub(R,Q-1)return P,Q+1 end;Q=Q+1 end;J(N,O,"expected closing quote for string")end;local O=function(O,P)local Q=H(O,P,B)local R=O:sub(P,Q-1)local S=tonumber(R)if not S then J(O,P,"invalid number '"..R.."'")end;return S,Q end;local P=function(P,Q)local R=H(P,Q,B)local S=P:sub(Q,R-1)if not F[S]then J(P,Q,"invalid literal '"..S.."'")end;return G[S],R end;local Q=function(Q,R)local S={}local T=1;R=R+1;while 1 do local U;R=H(Q,R,A,true)if Q:sub(R,R)=="]"then R=R+1;break end;U,R=x(Q,R)S[T]=U;T=T+1;R=H(Q,R,A,true)local V=Q:sub(R,R)R=R+1;if V=="]"then break end;if V~=","then J(Q,R,"expected ']' or ','")end end;return S,R end;local R=function(R,S)local T={}S=S+1;while 1 do local U,V;S=H(R,S,A,true)if R:sub(S,S)=="}"then S=S+1;break end;if R:sub(S,S)~='"'then J(R,S,"expected string for key")end;U,S=x(R,S)S=H(R,S,A,true)if R:sub(S,S)~=":"then J(R,S,"expected ':' after key")end;S=H(R,S+1,A,true)V,S=x(R,S)T[U]=V;S=H(R,S,A,true)local W=R:sub(S,S)S=S+1;if W=="}"then break end;if W~=","then J(R,S,"expected '}' or ','")end end;return T,S end;local S={['"']=N,["0"]=O,["1"]=O,["2"]=O,["3"]=O,["4"]=O,["5"]=O,["6"]=O,["7"]=O,["8"]=O,["9"]=O,["-"]=O,t=P,f=P,n=P,["["]=Q,["{"]=R}x=function(T,U)local V=T:sub(U,U)local W=S[V]if W then return W(T,U)end;J(T,U,"unexpected character '"..V.."'")end;local T=function(T)if type(T)~="string"then error("expected argument of type string, got "..type(T))end;local U,V=x(T,H(T,1,A,true))V=H(T,V,A,true)if V<=#T then J(T,V,"trailing garbage")end;return U end;
local U,V,W=v,T,Z;





local X={}


function X.New(Y,_)

local aa=Y;
local ab=_;
local ac=true;


local ad=function(ad)end;


repeat task.wait(1)until game:IsLoaded();


local ae=false;
local af,ag,ah,ai,aj,ak,al,am,an=setclipboard or toclipboard,request or http_request or syn_request,string.char,tostring,string.sub,os.time,math.random,math.floor,gethwid or function()return game:GetService"Players".LocalPlayer.UserId end
local ao,ap="",0;


local aq="https://api.platoboost.com";
local ar=ag{
Url=aq.."/public/connectivity",
Method="GET"
};
if ar.StatusCode~=200 or ar.StatusCode~=429 then
aq="https://api.platoboost.net";
end


function cacheLink()
if ap+(600)<ak()then
local as=ag{
Url=aq.."/public/start",
Method="POST",
Body=U{
service=aa,
identifier=W(an())
},
Headers={
["Content-Type"]="application/json",
["User-Agent"]="Roblox/Exploit"
}
};

if as.StatusCode==200 then
local at=V(as.Body);

if at.success==true then
ao=at.data.url;
ap=ak();
return true,ao
else
ad(at.message);
return false,at.message
end
elseif as.StatusCode==429 then
local at="you are being rate limited, please wait 20 seconds and try again.";
ad(at);
return false,at
end

local at="Failed to cache link.";
ad(at);
return false,at
else
return true,ao
end
end

cacheLink();


local as=function()
local as=""
for at=1,16 do
as=as..ah(am(al()*(26))+97)
end
return as
end


for at=1,5 do
local au=as();
task.wait(0.2)
if as()==au then
local av="platoboost nonce error.";
ad(av);
error(av);
end
end


local at=function()
local at,au=cacheLink();

if at then
af(au);
end
end


local au=function(au)
local av=as();
local aw=aq.."/public/redeem/"..ai(aa);

local ax={
identifier=W(an()),
key=au
}

if ac then
ax.nonce=av;
end

local ay=ag{
Url=aw,
Method="POST",
Body=U(ax),
Headers={
["Content-Type"]="application/json"
}
};

if ay.StatusCode==200 then
local az=V(ay.Body);

if az.success==true then
if az.data.valid==true then
if ac then
if az.data.hash==W("true".."-"..av.."-"..ab)then
return true
else
ad"failed to verify integrity.";
return false
end
else
return true
end
else
ad"key is invalid.";
return false
end
else
if aj(az.message,1,27)=="unique constraint violation"then
ad"you already have an active key, please wait for it to expire before redeeming it.";
return false
else
ad(az.message);
return false
end
end
elseif ay.StatusCode==429 then
ad"you are being rate limited, please wait 20 seconds and try again.";
return false
else
ad"server returned an invalid status code, please try again later.";
return false
end
end


local av=function(av)
if ae==true then
return false,("A request is already being sent, please slow down.")
else
ae=true;
end

local aw=as();
local ax=aq.."/public/whitelist/"..ai(aa).."?identifier="..W(an()).."&key="..av;

if ac then
ax=ax.."&nonce="..aw;
end

local ay=ag{
Url=ax,
Method="GET",
};

ae=false;

if ay.StatusCode==200 then
local az=V(ay.Body);

if az.success==true then
if az.data.valid==true then
if ac then
if az.data.hash==W("true".."-"..aw.."-"..ab)then
return true,""
else
return false,("failed to verify integrity.")
end
else
return true
end
else
if aj(av,1,4)=="KEY_"then
return true,au(av)
else
return false,("Key is invalid.")
end
end
else
return false,(az.message)
end
elseif ay.StatusCode==429 then
return false,("You are being rate limited, please wait 20 seconds and try again.")
else
return false,("Server returned an invalid status code, please try again later.")
end
end


local aw=function(aw)
local ax=as();
local ay=aq.."/public/flag/"..ai(aa).."?name="..aw;

if ac then
ay=ay.."&nonce="..ax;
end

local az=ag{
Url=ay,
Method="GET",
};

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if ac then
if aA.data.hash==W(ai(aA.data.value).."-"..ax.."-"..ab)then
return aA.data.value
else
ad"failed to verify integrity.";
return nil
end
else
return aA.data.value
end
else
ad(aA.message);
return nil
end
else
return nil
end
end


return{
Verify=av,
GetFlag=aw,
Copy=at,
}
end


return X end function a.e()








local aa=game:GetService"HttpService"
local ab={}


function ab.New(ac)
local ad=gethwid or function()return game:GetService"Players".LocalPlayer.UserId end
local ae,af=request or http_request or syn_request,setclipboard or toclipboard

function ValidateKey(ag)
local ah="https://pandadevelopment.net/v2_validation?key="..tostring(ag).."&service="..tostring(ac).."&hwid="..tostring(ad())


local ai,aj=pcall(function()
return ae{
Url=ah,
Method="GET",
Headers={["User-Agent"]="Roblox/Exploit"}
}
end)

if ai and aj then
if aj.Success then
local ak,al=pcall(function()
return aa:JSONDecode(aj.Body)
end)

if ak and al then
if al.V2_Authentication and al.V2_Authentication=="success"then

return true,"Authenticated"
else
local am=al.Key_Information.Notes or"Unknown reason"

return false,"Authentication failed: "..am
end
else

return false,"JSON decode error"
end
else
warn("[Pelinda Ov2.5] HTTP request was not successful. Code: "..tostring(aj.StatusCode).." Message: "..aj.StatusMessage)
return false,"HTTP request failed: "..aj.StatusMessage
end
else

return false,"Request pcall error"
end
end

function GetKeyLink()
return"https://pandadevelopment.net/getkey?service="..tostring(ac).."&hwid="..tostring(ad())
end

function CopyLink()
return af(GetKeyLink())
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end

return ab end function a.f()








local aa={}


function aa.New(ab,ac)
local ad="https://sdkapi-public.luarmor.net/library.lua"

local ae=loadstring(
game.HttpGetAsync and game:HttpGetAsync(ad)
or HttpService:GetAsync(ad)
)()
local af=setclipboard or toclipboard

ae.script_id=ab

function ValidateKey(ag)
local ah=ae.check_key(ag);


if(ah.code=="KEY_VALID")then
return true,"Whitelisted!"

elseif(ah.code=="KEY_HWID_LOCKED")then
return false,"Key linked to a different HWID. Please reset it using our bot"

elseif(ah.code=="KEY_INCORRECT")then
return false,"Key is wrong or deleted!"
else
return false,"Key check failed:"..ah.message.." Code: "..ah.code
end
end

function CopyLink()
af(tostring(ac))
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end


return aa end function a.g()
return{
platoboost={
Name="Platoboost",
Icon="rbxassetid://75920162824531",
Args={"ServiceId","Secret"},


New=a.load'd'.New
},
pandadevelopment={
Name="Panda Development",
Icon="panda",
Args={"ServiceId"},


New=a.load'e'.New
},
luarmor={
Name="Luarmor",
Icon="rbxassetid://130918283130165",
Args={"ScriptId","Discord"},


New=a.load'f'.New
},

}end function a.h()


return[[
{
    "name": "windui",
    "version": "1.6.53",
    "main": "./dist/main.lua",
    "repository": "https://github.com/Footagesus/WindUI",
    "discord": "https://discord.gg/ftgs-development-hub-1300692552005189632",
    "author": "Footagesus",
    "description": "Roblox UI Library for scripts",
    "license": "MIT",
    "scripts": {
        "dev": "sh build/build.sh dev $INPUT_FILE",
        "build": "sh build/build.sh build $INPUT_FILE",
        "live": "python -m http.server 8642",
        "watch": "chokidar . -i 'node_modules' -i 'dist' -i 'build' -c 'npm run dev --'",
        "live-build": "concurrently \"npm run live\" \"npm run watch --\"",
        "updater": "python updater/main.py"
    },
    "keywords": [
        "ui-library",
        "ui-design",
        "script",
        "script-hub",
        "exploiting"
    ],
    "devDependencies": {
        "chokidar-cli": "^3.0.0",
        "concurrently": "^9.2.0"
    }
}]]end function a.i()

local aa={}

local ab=a.load'a'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj,ak)
ah=ah or"Primary"
local al=not ak and 10 or 99
local am
if af and af~=""then
am=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ah=="White"and.4 or 0,
ThemeTag={
ImageColor3=ah~="White"and"Icon"or nil,
}
})
end

local an=ac("TextButton",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=ai,
BackgroundTransparency=1
},{
ab.NewRoundFrame(al,"Squircle",{
ThemeTag={
ImageColor3=ah~="White"and"Button"or nil,
},
ImageColor3=ah=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=ah=="Primary"and 0 or ah=="White"and 0 or 1
}),

ab.NewRoundFrame(al,"Squircle",{



ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=ah=="Secondary"and 0.95 or 1
}),

ab.NewRoundFrame(al,"Shadow-sm",{



ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",

ImageTransparency=1,
Visible=not ak
}),

ab.NewRoundFrame(al,not ak and"SquircleOutline"or"SquircleOutline2",{
ThemeTag={
ImageColor3=ah~="White"and"Outline"or nil,
},
Size=UDim2.new(1,0,1,0),
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ah=="Primary"and.95 or.85,
Name="SquircleOutline",
},{
ac("UIGradient",{
Rotation=70,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),

ab.NewRoundFrame(al,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=ah~="White"and"Text"or nil
},
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1
},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
am,
ac("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ae or"Button",
ThemeTag={
TextColor3=(ah~="Primary"and ah~="White")and"Text",
},
TextColor3=ah=="Primary"and Color3.new(1,1,1)or ah=="White"and Color3.new(0,0,0)or nil,
AutomaticSize="XY",
TextSize=18,
})
})
})

ab.AddSignal(an.MouseEnter,function()
ad(an.Frame,.047,{ImageTransparency=.95}):Play()
end)
ab.AddSignal(an.MouseLeave,function()
ad(an.Frame,.047,{ImageTransparency=1}):Play()
end)
ab.AddSignal(an.MouseButton1Up,function()
if aj then
aj:Close()()
end
if ag then
ab.SafeCallback(ag)
end
end)

return an
end


return aa end function a.j()
local aa={}

local ab=a.load'a'
local ac=ab.New local ad=
ab.Tween


function aa.New(ae,af,ag,ah,ai,aj,ak,al)
ah=ah or"Input"
local am=ak or 10
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local ao=ah~="Input"

local ap=ac("TextBox",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,an and-29 or 0,1,0),
PlaceholderText=ae,
ClearTextOnFocus=al or false,
ClipsDescendants=true,
TextWrapped=ao,
MultiLine=ao,
TextXAlignment="Left",
TextYAlignment=ah=="Input"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local aq=ac("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(am,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.95,
},{













}),
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,ah=="Input"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,ah=="Input"and 0 or 12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=ah=="Input"and"Center"or"Top",
HorizontalAlignment="Left",
}),
an,
ap,
})
})
})










if aj then
ab.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
else
ab.AddSignal(ap.FocusLost,function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
end

return aq
end


return aa end function a.k()
local aa=a.load'a'
local ab=aa.New
local ac=aa.Tween



local ad={
Holder=nil,

Parent=nil,
}

function ad.Init(ae,af)
Window=ae
ad.Parent=af
return ad
end

function ad.Create(ae)
local af={
UICorner=24,
UIPadding=15,
UIElements={}
}

if ae then af.UIPadding=0 end
if ae then af.UICorner=26 end

if not ae then
af.UIElements.FullScreen=ab("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=ad.Parent or(Window and Window.UIElements and Window.UIElements.Main and Window.UIElements.Main.Main)
},{
ab("UICorner",{
CornerRadius=UDim.new(0,Window.UICorner)
})
})
end

af.UIElements.Main=ab("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3="Dialog",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,af.UIPadding),
PaddingLeft=UDim.new(0,af.UIPadding),
PaddingRight=UDim.new(0,af.UIPadding),
PaddingBottom=UDim.new(0,af.UIPadding),
})
})

af.UIElements.MainContainer=aa.NewRoundFrame(af.UICorner,"Squircle",{
Visible=false,

ImageTransparency=ae and 0.15 or 0,
Parent=ae and ad.Parent or af.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3="Dialog"
},
ZIndex=9999,
},{





af.UIElements.Main,



aa.NewRoundFrame(af.UICorner,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ThemeTag={
ImageColor3="Outline",
},
},{
ab("UIGradient",{
Rotation=45,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.55),
NumberSequenceKeypoint.new(0.5,0.8),
NumberSequenceKeypoint.new(1,0.6)
}
})
})
})

function af.Open(ag)
if not ae then
af.UIElements.FullScreen.Visible=true
af.UIElements.FullScreen.Active=true
end

task.spawn(function()
af.UIElements.MainContainer.Visible=true

if not ae then
ac(af.UIElements.FullScreen,0.1,{BackgroundTransparency=.3}):Play()
end
ac(af.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()


task.spawn(function()
task.wait(0.05)
af.UIElements.Main.Visible=true
end)
end)
end
function af.Close(ag)
if not ae then
ac(af.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
af.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(.1)
af.UIElements.FullScreen.Visible=false
end)
end
af.UIElements.Main.Visible=false

ac(af.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()



task.spawn(function()
task.wait(.1)
if not ae then
af.UIElements.FullScreen:Destroy()
else
af.UIElements.MainContainer:Destroy()
end
end)

return function()end
end


return af
end

return ad end function a.l()
local aa={}


local ab=a.load'a'
local ac=ab.New
local ad=ab.Tween

local ae=a.load'i'.New
local af=a.load'j'.New

function aa.new(ag,ah,ai)
local aj=a.load'k'.Init(nil,ag.WindUI.ScreenGui.KeySystem)
local ak=aj.Create(true)

local al={}

local am

local an=(ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Width)or 200

local ao=430
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
ao=430+(an/2)
end

ak.UIElements.Main.AutomaticSize="Y"
ak.UIElements.Main.Size=UDim2.new(0,ao,0,0)

local ap

if ag.Icon then

ap=ab.Image(
ag.Icon,
ag.Title..":"..ag.Icon,
0,
"Temp",
"KeySystem",
ag.IconThemed
)
ap.Size=UDim2.new(0,24,0,24)
ap.LayoutOrder=-1
end

local aq=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=ag.Title,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20
})
local ar=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text="Key System",
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,0,0.5,0),
TextTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
TextSize=16
})

local as=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
ap,aq
})

local at=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





as,ar,
})

local au=af("Enter Key","key",nil,"Input",function(au)
am=au
end)

local av
if ag.KeySystem.Note and ag.KeySystem.Note~=""then
av=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ag.KeySystem.Note,
TextSize=18,
TextTransparency=.4,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local aw=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
})
})
})


local ax
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
local ay
if ag.KeySystem.Thumbnail.Title then
ay=ac("TextLabel",{
Text=ag.KeySystem.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
ax=ac("ImageLabel",{
Image=ag.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,an,1,-12),
Position=UDim2.new(0,6,0,6),
Parent=ak.UIElements.Main,
ScaleType="Crop"
},{
ay,
ac("UICorner",{
CornerRadius=UDim.new(0,20),
})
})
end

ac("Frame",{

Size=UDim2.new(1,ax and-an or 0,1,0),
Position=UDim2.new(0,ax and an or 0,0,0),
BackgroundTransparency=1,
Parent=ak.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
at,
av,
au,
aw,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})





local ay=ae("Exit","log-out",function()
ak:Close()()
end,"Tertiary",aw.Frame)

if ax then
ay.Parent=ax
ay.Size=UDim2.new(0,0,0,42)
ay.Position=UDim2.new(0,10,1,-10)
ay.AnchorPoint=Vector2.new(0,1)
end

if ag.KeySystem.URL then
ae("Get key","key",function()
setclipboard(ag.KeySystem.URL)
end,"Secondary",aw.Frame)
end

if ag.KeySystem.API then








local az=240
local aA=false
local b=ae("Get key","key",nil,"Secondary",aw.Frame)

local e=ab.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,1,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=.9,
})

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=b.Frame,
},{
e,
ac("UIPadding",{
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
})
})

local g=ab.Image(
"chevron-down",
"chevron-down",
0,
"Temp",
"KeySystem",
true
)

g.Size=UDim2.new(1,0,1,0)

ac("Frame",{
Size=UDim2.new(0,21,0,21),
Parent=b.Frame,
BackgroundTransparency=1,
},{
g
})

local h=ab.NewRoundFrame(15,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Background",
},
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,5),
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
}),
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
})
})

local i=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,az,0,0),
ClipsDescendants=true,
AnchorPoint=Vector2.new(1,0),
Parent=b,
Position=UDim2.new(1,0,1,15)
},{
h
})

ac("TextLabel",{
Text="Select Service",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
Parent=h,
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
})
})

for j,l in next,ag.KeySystem.API do
local m=ag.WindUI.Services[l.Type]
if m then
local p={}
for r,u in next,m.Args do
table.insert(p,l[u])
end

local r=m.New(table.unpack(p))
r.Type=l.Type
table.insert(al,r)

local u=ab.Image(
l.Icon or m.Icon or Icons[l.Type]or"user",
l.Icon or m.Icon or Icons[l.Type]or"user",
0,
"Temp",
"KeySystem",
true
)
u.Size=UDim2.new(0,24,0,24)

local v=ab.NewRoundFrame(10,"Squircle",{
Size=UDim2.new(1,0,0,0),
ThemeTag={ImageColor3="Text"},
ImageTransparency=1,
Parent=h,
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
u,
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,-34,0,0),
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
HorizontalAlignment="Center",
}),
ac("TextLabel",{
Text=l.Title or m.Name,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.05,
TextSize=18,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
}),
ac("TextLabel",{
Text=l.Desc or"",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
Visible=l.Desc and true or false,
TextXAlignment="Left",
})
})
},true)

ab.AddSignal(v.MouseEnter,function()
ad(v,0.08,{ImageTransparency=.95}):Play()
end)
ab.AddSignal(v.InputEnded,function()
ad(v,0.08,{ImageTransparency=1}):Play()
end)
ab.AddSignal(v.MouseButton1Click,function()
r.Copy()
ag.WindUI:Notify{
Title="Key System",
Content="Key link copied to clipboard.",
Image="key",
}
end)
end
end

ab.AddSignal(b.MouseButton1Click,function()
if not aA then
ad(i,.3,{Size=UDim2.new(0,az,0,h.AbsoluteSize.Y+1)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(g,.3,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ad(i,.25,{Size=UDim2.new(0,az,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(g,.25,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
aA=not aA
end)

end

local function handleSuccess(az)
ak:Close()()
writefile((ag.Folder or ag.Title).."/"..ah..".key",tostring(az))
task.wait(.4)
ai(true)
end

local az=ae("Submit","arrow-right",function()
local az=tostring(am or"empty")local aA=
ag.Folder or ag.Title

if not ag.KeySystem.API then
local b=type(ag.KeySystem.Key)=="table"
and table.find(ag.KeySystem.Key,az)
or ag.KeySystem.Key==az

if b then
if ag.KeySystem.SaveKey then
handleSuccess(az)
else
ak:Close()()
task.wait(.4)
ai(true)
end
end
else
local b,e
for g,h in next,al do
local i,j=h.Verify(az)
if i then
b,e=true,j
break
end
e=j
end

if b then
handleSuccess(az)
else
ag.WindUI:Notify{
Title="Key System. Error",
Content=e,
Icon="triangle-alert",
}
end
end
end,"Primary",aw)

az.AnchorPoint=Vector2.new(1,0.5)
az.Position=UDim2.new(1,0,0.5,0)










ak:Open()
end

return aa end function a.m()


local function map(aa,ab,ac,ad,ae)
return(aa-ab)*(ae-ad)/(ac-ab)+ad
end

local function viewportPointToWorld(aa,ab)
local ac=game:GetService"Workspace".CurrentCamera:ScreenPointToRay(aa.X,aa.Y)
return ac.Origin+ac.Direction*ab
end

local function getOffset()
local aa=game:GetService"Workspace".CurrentCamera.ViewportSize.Y
return map(aa,0,2560,8,56)
end

return{viewportPointToWorld,getOffset}end function a.n()



local aa=a.load'a'
local ab=aa.New


local ac,ad=unpack(a.load'm')
local ae=Instance.new("Folder",game:GetService"Workspace".CurrentCamera)


local function createAcrylic()
local af=ab("Part",{
Name="Body",
Color=Color3.new(0,0,0),
Material=Enum.Material.Glass,
Size=Vector3.new(1,1,0),
Anchored=true,
CanCollide=false,
Locked=true,
CastShadow=false,
Transparency=0.98,
},{
ab("SpecialMesh",{
MeshType=Enum.MeshType.Brick,
Offset=Vector3.new(0,0,-1E-6),
}),
})

return af
end


local function createAcrylicBlur(af)
local ag={}

af=af or 0.001
local ah={
topLeft=Vector2.new(),
topRight=Vector2.new(),
bottomRight=Vector2.new(),
}
local ai=createAcrylic()
ai.Parent=ae

local function updatePositions(aj,ak)
ah.topLeft=ak
ah.topRight=ak+Vector2.new(aj.X,0)
ah.bottomRight=ak+aj
end

local function render()
local aj=game:GetService"Workspace".CurrentCamera
if aj then
aj=aj.CFrame
end
local ak=aj
if not ak then
ak=CFrame.new()
end

local al=ak
local am=ah.topLeft
local an=ah.topRight
local ao=ah.bottomRight

local ap=ac(am,af)
local aq=ac(an,af)
local ar=ac(ao,af)

local as=(aq-ap).Magnitude
local at=(aq-ar).Magnitude

ai.CFrame=
CFrame.fromMatrix((ap+ar)/2,al.XVector,al.YVector,al.ZVector)
ai.Mesh.Scale=Vector3.new(as,at,0)
end

local function onChange(aj)
local ak=ad()
local al=aj.AbsoluteSize-Vector2.new(ak,ak)
local am=aj.AbsolutePosition+Vector2.new(ak/2,ak/2)

updatePositions(al,am)
task.spawn(render)
end

local function renderOnChange()
local aj=game:GetService"Workspace".CurrentCamera
if not aj then
return
end

table.insert(ag,aj:GetPropertyChangedSignal"CFrame":Connect(render))
table.insert(ag,aj:GetPropertyChangedSignal"ViewportSize":Connect(render))
table.insert(ag,aj:GetPropertyChangedSignal"FieldOfView":Connect(render))
task.spawn(render)
end

ai.Destroying:Connect(function()
for aj,ak in ag do
pcall(function()
ak:Disconnect()
end)
end
end)

renderOnChange()

return onChange,ai
end

return function(af)
local ag={}
local ah,ai=createAcrylicBlur(af)

local aj=ab("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
})

aa.AddSignal(aj:GetPropertyChangedSignal"AbsolutePosition",function()
ah(aj)
end)

aa.AddSignal(aj:GetPropertyChangedSignal"AbsoluteSize",function()
ah(aj)
end)

ag.AddParent=function(ak)
aa.AddSignal(ak:GetPropertyChangedSignal"Visible",function()
ag.SetVisibility(ak.Visible)
end)
end

ag.SetVisibility=function(ak)
ai.Transparency=ak and 0.98 or 1
end

ag.Frame=aj
ag.Model=ai

return ag
end end function a.o()



local aa=a.load'a'
local ab=a.load'n'

local ac=aa.New

return function(ad)
local ae={}

ae.Frame=ac("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,
},{












ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Name="Background",
ThemeTag={
BackgroundColor3="AcrylicMain",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{










}),

ac("ImageLabel",{
Image="rbxassetid://9968344105",
ImageTransparency=0.98,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("ImageLabel",{
Image="rbxassetid://9968344227",
ImageTransparency=0.9,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ThemeTag={
ImageTransparency="AcrylicNoise",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ZIndex=2,
},{










}),
})


local af

task.wait()
if ad.UseAcrylic then
af=ab()

af.Frame.Parent=ae.Frame
ae.Model=af.Model
ae.AddParent=af.AddParent
ae.SetVisibility=af.SetVisibility
end

return ae,af
end end function a.p()



local aa={
AcrylicBlur=a.load'n',

AcrylicPaint=a.load'o',
}

function aa.init()
local ab=Instance.new"DepthOfFieldEffect"
ab.FarIntensity=0
ab.InFocusRadius=0.1
ab.NearIntensity=1

local ac={}

function aa.Enable()
for ad,ae in pairs(ac)do
ae.Enabled=false
end
ab.Parent=game:GetService"Lighting"
end

function aa.Disable()
for ad,ae in pairs(ac)do
ae.Enabled=ae.enabled
end
ab.Parent=nil
end

local function registerDefaults()
local function register(ad)
if ad:IsA"DepthOfFieldEffect"then
ac[ad]={enabled=ad.Enabled}
end
end

for ad,ae in pairs(game:GetService"Lighting":GetChildren())do
register(ae)
end

if game:GetService"Workspace".CurrentCamera then
for ad,ae in pairs(game:GetService"Workspace".CurrentCamera:GetChildren())do
register(ae)
end
end
end

registerDefaults()
aa.Enable()
end

return aa end function a.q()

local aa={}

local ab=a.load'a'
local ac=ab.New local ad=
ab.Tween


function aa.new(ae)
local af={
Title=ae.Title or"Dialog",
Content=ae.Content,
Icon=ae.Icon,
IconThemed=ae.IconThemed,
Thumbnail=ae.Thumbnail,
Buttons=ae.Buttons,

IconSize=22,
}

local ag=a.load'k'.Init(nil,ae.WindUI.ScreenGui.Popups)
local ah=ag.Create(true)

local ai=200

local aj=430
if af.Thumbnail and af.Thumbnail.Image then
aj=430+(ai/2)
end

ah.UIElements.Main.AutomaticSize="Y"
ah.UIElements.Main.Size=UDim2.new(0,aj,0,0)



local ak

if af.Icon then
ak=ab.Image(
af.Icon,
af.Title..":"..af.Icon,
0,
ae.WindUI.Window,
"Popup",
true,
ae.IconThemed
)
ak.Size=UDim2.new(0,af.IconSize,0,af.IconSize)
ak.LayoutOrder=-1
end


local al=ac("TextLabel",{
AutomaticSize="Y",
BackgroundTransparency=1,
Text=af.Title,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20,
TextWrapped=true,
Size=UDim2.new(1,ak and-af.IconSize-14 or 0,0,0)
})

local am=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
ak,al
})

local an=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





am,
})

local ao
if af.Content and af.Content~=""then
ao=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=af.Content,
TextSize=18,
TextTransparency=.2,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ap=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local aq
if af.Thumbnail and af.Thumbnail.Image then
local ar
if af.Thumbnail.Title then
ar=ac("TextLabel",{
Text=af.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
aq=ac("ImageLabel",{
Image=af.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ai,1,0),
Parent=ah.UIElements.Main,
ScaleType="Crop"
},{
ar,
ac("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

ac("Frame",{

Size=UDim2.new(1,aq and-ai or 0,1,0),
Position=UDim2.new(0,aq and ai or 0,0,0),
BackgroundTransparency=1,
Parent=ah.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
an,
ao,
ap,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})

local ar=a.load'i'.New

for as,at in next,af.Buttons do
ar(at.Title,at.Icon,at.Callback,at.Variant,ap,ah)
end

ah:Open()


return af
end

return aa end function a.r()
return function(aa)
return{
Dark={
Name="Dark",

Accent=Color3.fromHex"#18181b",
Dialog=Color3.fromHex"#161616",
Outline=Color3.fromHex"#FFFFFF",
Text=Color3.fromHex"#FFFFFF",
Placeholder=Color3.fromHex"#7a7a7a",
Background=Color3.fromHex"#101010",
Button=Color3.fromHex"#52525b",
Icon=Color3.fromHex"#a1a1aa"
},
Light={
Name="Light",

Accent=Color3.fromHex"#FFFFFF",
Dialog=Color3.fromHex"#f4f4f5",
Outline=Color3.fromHex"#09090b",
Text=Color3.fromHex"#000000",
Placeholder=Color3.fromHex"#555555",
Background=Color3.fromHex"#e4e4e7",
Button=Color3.fromHex"#18181b",
Icon=Color3.fromHex"#52525b",
},
Rose={
Name="Rose",

Accent=Color3.fromHex"#be185d",
Dialog=Color3.fromHex"#4c0519",
Outline=Color3.fromHex"#fecdd3",
Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#d67aa6",
Background=Color3.fromHex"#1f0308",
Button=Color3.fromHex"#e11d48",
Icon=Color3.fromHex"#fb7185",
},
Plant={
Name="Plant",

Accent=Color3.fromHex"#166534",
Dialog=Color3.fromHex"#052e16",
Outline=Color3.fromHex"#bbf7d0",
Text=Color3.fromHex"#f0fdf4",
Placeholder=Color3.fromHex"#4fbf7a",
Background=Color3.fromHex"#0a1b0f",
Button=Color3.fromHex"#16a34a",
Icon=Color3.fromHex"#4ade80",
},
Red={
Name="Red",

Accent=Color3.fromHex"#991b1b",
Dialog=Color3.fromHex"#450a0a",
Outline=Color3.fromHex"#fecaca",
Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#d95353",
Background=Color3.fromHex"#1c0606",
Button=Color3.fromHex"#dc2626",
Icon=Color3.fromHex"#ef4444",
},
Indigo={
Name="Indigo",

Accent=Color3.fromHex"#3730a3",
Dialog=Color3.fromHex"#1e1b4b",
Outline=Color3.fromHex"#c7d2fe",
Text=Color3.fromHex"#f1f5f9",
Placeholder=Color3.fromHex"#7078d9",
Background=Color3.fromHex"#0f0a2e",
Button=Color3.fromHex"#4f46e5",
Icon=Color3.fromHex"#6366f1",
},
Sky={
Name="Sky",

Accent=Color3.fromHex"#0369a1",
Dialog=Color3.fromHex"#0c4a6e",
Outline=Color3.fromHex"#bae6fd",
Text=Color3.fromHex"#f0f9ff",
Placeholder=Color3.fromHex"#4fb6d9",
Background=Color3.fromHex"#041f2e",
Button=Color3.fromHex"#0284c7",
Icon=Color3.fromHex"#0ea5e9",
},
Violet={
Name="Violet",

Accent=Color3.fromHex"#6d28d9",
Dialog=Color3.fromHex"#3c1361",
Outline=Color3.fromHex"#ddd6fe",
Text=Color3.fromHex"#faf5ff",
Placeholder=Color3.fromHex"#8f7ee0",
Background=Color3.fromHex"#1e0a3e",
Button=Color3.fromHex"#7c3aed",
Icon=Color3.fromHex"#8b5cf6",
},
Amber={
Name="Amber",

Accent=Color3.fromHex"#b45309",
Dialog=Color3.fromHex"#451a03",
Outline=Color3.fromHex"#fde68a",
Text=Color3.fromHex"#fffbeb",
Placeholder=Color3.fromHex"#d1a326",
Background=Color3.fromHex"#1c1003",
Button=Color3.fromHex"#d97706",
Icon=Color3.fromHex"#f59e0b",
},
Emerald={
Name="Emerald",

Accent=Color3.fromHex"#047857",
Dialog=Color3.fromHex"#022c22",
Outline=Color3.fromHex"#a7f3d0",
Text=Color3.fromHex"#ecfdf5",
Placeholder=Color3.fromHex"#3fbf8f",
Background=Color3.fromHex"#011411",
Button=Color3.fromHex"#059669",
Icon=Color3.fromHex"#10b981",
},
Midnight={
Name="Midnight",

Accent=Color3.fromHex"#1e3a8a",
Dialog=Color3.fromHex"#0c1e42",
Outline=Color3.fromHex"#bfdbfe",
Text=Color3.fromHex"#dbeafe",
Placeholder=Color3.fromHex"#2f74d1",
Background=Color3.fromHex"#0a0f1e",
Button=Color3.fromHex"#2563eb",
Icon=Color3.fromHex"#3b82f6",
},
Crimson={
Name="Crimson",

Accent=Color3.fromHex"#b91c1c",
Dialog=Color3.fromHex"#450a0a",
Outline=Color3.fromHex"#fca5a5",
Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#6f757b",
Background=Color3.fromHex"#0c0404",
Button=Color3.fromHex"#991b1b",
Icon=Color3.fromHex"#dc2626",
},
MonokaiPro={
Name="Monokai Pro",

Accent=Color3.fromHex"#fc9867",
Dialog=Color3.fromHex"#1e1e1e",
Outline=Color3.fromHex"#78dce8",
Text=Color3.fromHex"#fcfcfa",
Placeholder=Color3.fromHex"#6f6f6f",
Background=Color3.fromHex"#191622",
Button=Color3.fromHex"#ab9df2",
Icon=Color3.fromHex"#a9dc76",
},
CottonCandy={
Name="Cotton Candy",

Accent=Color3.fromHex"#ec4899",
Dialog=Color3.fromHex"#2d1b3d",
Outline=Color3.fromHex"#f9a8d4",
Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#8a5fd3",
Background=Color3.fromHex"#1a0b2e",
Button=Color3.fromHex"#d946ef",
Icon=Color3.fromHex"#06b6d4",
},
Rainbow={
Name="Rainbow",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#00ff41",Transparency=0},
["33"]={Color=Color3.fromHex"#00ffff",Transparency=0},
["66"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["100"]={Color=Color3.fromHex"#8000ff",Transparency=0},
},{
Rotation=45,
}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#8000ff",Transparency=0},
["50"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["75"]={Color=Color3.fromHex"#00ff80",Transparency=0},
["100"]={Color=Color3.fromHex"#ff8000",Transparency=0},
},{
Rotation=135,
}),

Outline=Color3.fromHex"#ffffff",
Text=Color3.fromHex"#ffffff",

Placeholder=Color3.fromHex"#00ff80",

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0040",Transparency=0},
["20"]={Color=Color3.fromHex"#ff4000",Transparency=0},
["40"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["60"]={Color=Color3.fromHex"#00ff40",Transparency=0},
["80"]={Color=Color3.fromHex"#0040ff",Transparency=0},
["100"]={Color=Color3.fromHex"#4000ff",Transparency=0},
},{
Rotation=90,
}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#ff8000",Transparency=0},
["50"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["75"]={Color=Color3.fromHex"#80ff00",Transparency=0},
["100"]={Color=Color3.fromHex"#00ffff",Transparency=0},
},{
Rotation=60,
}),

Icon=Color3.fromHex"#ffffff",
}
}
end end function a.s()
local aa={}

local ab=a.load'a'
local ac=ab.New local ad=
ab.Tween


function aa.New(ae,af,ag,ah)
local ai=10
local aj
if af and af~=""then
aj=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local ak=ac("TextLabel",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,aj and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3=ah and"Placeholder"or"Text",
},
Text=ae,
})

local al=ac("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1,
Text="",
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(ai,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(ai,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.95,
},{
ac("UIGradient",{
Rotation=70,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),
ab.NewRoundFrame(ai,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
aj,
ak,
})
})
})

return al
end


return aa end function a.t()
local aa={}

local ab=game:GetService"UserInputService"

local ac=a.load'a'
local ad=ac.New local ae=
ac.Tween


function aa.New(af,ag,ah,ai)
local aj=ad("Frame",{
Size=UDim2.new(0,ai,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=ag,
ZIndex=999,
Active=true,
})

local ak=ac.NewRoundFrame(ai/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=aj,
})

local al=ad("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=ak,
})

local am=false
local an=0

local function updateSliderSize()
local ao=af
local ap=ao.AbsoluteCanvasSize.Y
local aq=ao.AbsoluteWindowSize.Y

if ap<=aq then
ak.Visible=false
return
end

local ar=math.clamp(aq/ap,0.1,1)
ak.Size=UDim2.new(1,0,ar,0)
ak.Visible=true
end

local function updateScrollingFramePosition()
local ao=ak.Position.Y.Scale
local ap=af.AbsoluteCanvasSize.Y
local aq=af.AbsoluteWindowSize.Y
local ar=math.max(ap-aq,0)

if ar<=0 then return end

local as=math.max(1-ak.Size.Y.Scale,0)
if as<=0 then return end

local at=ao/as

af.CanvasPosition=Vector2.new(
af.CanvasPosition.X,
at*ar
)
end

local function updateThumbPosition()
if am then return end

local ao=af.CanvasPosition.Y
local ap=af.AbsoluteCanvasSize.Y
local aq=af.AbsoluteWindowSize.Y
local ar=math.max(ap-aq,0)

if ar<=0 then
ak.Position=UDim2.new(0,0,0,0)
return
end

local as=ao/ar
local at=math.max(1-ak.Size.Y.Scale,0)
local au=math.clamp(as*at,0,at)

ak.Position=UDim2.new(0,0,au,0)
end

ac.AddSignal(aj.InputBegan,function(ao)
if(ao.UserInputType==Enum.UserInputType.MouseButton1 or ao.UserInputType==Enum.UserInputType.Touch)then
local ap=ak.AbsolutePosition.Y
local aq=ap+ak.AbsoluteSize.Y

if not(ao.Position.Y>=ap and ao.Position.Y<=aq)then
local ar=aj.AbsolutePosition.Y
local as=aj.AbsoluteSize.Y
local at=ak.AbsoluteSize.Y

local au=ao.Position.Y-ar-at/2
local av=as-at

local aw=math.clamp(au/av,0,1-ak.Size.Y.Scale)

ak.Position=UDim2.new(0,0,aw,0)
updateScrollingFramePosition()
end
end
end)

ac.AddSignal(al.InputBegan,function(ao)
if ao.UserInputType==Enum.UserInputType.MouseButton1 or ao.UserInputType==Enum.UserInputType.Touch then
am=true
an=ao.Position.Y-ak.AbsolutePosition.Y

local ap
local aq

ap=ab.InputChanged:Connect(function(ar)
if ar.UserInputType==Enum.UserInputType.MouseMovement or ar.UserInputType==Enum.UserInputType.Touch then
local as=aj.AbsolutePosition.Y
local at=aj.AbsoluteSize.Y
local au=ak.AbsoluteSize.Y

local av=ar.Position.Y-as-an
local aw=at-au

local ax=math.clamp(av/aw,0,1-ak.Size.Y.Scale)

ak.Position=UDim2.new(0,0,ax,0)
updateScrollingFramePosition()
end
end)

aq=ab.InputEnded:Connect(function(ar)
if ar.UserInputType==Enum.UserInputType.MouseButton1 or ar.UserInputType==Enum.UserInputType.Touch then
am=false
if ap then ap:Disconnect()end
if aq then aq:Disconnect()end
end
end)
end
end)

ac.AddSignal(af:GetPropertyChangedSignal"AbsoluteWindowSize",function()
updateSliderSize()
updateThumbPosition()
end)

ac.AddSignal(af:GetPropertyChangedSignal"AbsoluteCanvasSize",function()
updateSliderSize()
updateThumbPosition()
end)

ac.AddSignal(af:GetPropertyChangedSignal"CanvasPosition",function()
if not am then
updateThumbPosition()
end
end)

updateSliderSize()
updateThumbPosition()

return aj
end


return aa end function a.u()
local aa={}


local ab=a.load'a'
local ac=ab.New
local ad=ab.Tween

local function Color3ToHSB(ae)
local af,ag,ah=ae.R,ae.G,ae.B
local ai=math.max(af,ag,ah)
local aj=math.min(af,ag,ah)
local ak=ai-aj

local al=0
if ak~=0 then
if ai==af then
al=(ag-ah)/ak%6
elseif ai==ag then
al=(ah-af)/ak+2
else
al=(af-ag)/ak+4
end
al=al*60
else
al=0
end

local am=(ai==0)and 0 or(ak/ai)
local an=ai

return{
h=math.floor(al+0.5),
s=am,
b=an
}
end

local function GetPerceivedBrightness(ae)
local af=ae.R
local ag=ae.G
local ah=ae.B
return 0.299*af+0.587*ag+0.114*ah
end

local function GetTextColorForHSB(ae)
local af=Color3ToHSB(ae)local
ag, ah, ai=af.h, af.s, af.b
if GetPerceivedBrightness(ae)>0.5 then
return Color3.fromHSV(ag/360,0,0.05)
else
return Color3.fromHSV(ag/360,0,0.98)
end
end

local function GetAverageColor(ae)
local af,ag,ah=0,0,0
local ai=ae.Color.Keypoints
for aj,ak in ipairs(ai)do

af=af+ak.Value.R
ag=ag+ak.Value.G
ah=ah+ak.Value.B
end
local aj=#ai
return Color3.new(af/aj,ag/aj,ah/aj)
end


function aa.New(ae,af,ag)
local ah={
Title=af.Title or"Tag",
Color=af.Color or Color3.fromHex"#315dff",
Radius=af.Radius or 999,

TagFrame=nil,
Height=26,
Padding=10,
TextSize=14,
}

local ai=ac("TextLabel",{
BackgroundTransparency=1,
AutomaticSize="XY",
TextSize=ah.TextSize,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ah.Title,
TextColor3=typeof(ah.Color)=="Color3"and GetTextColorForHSB(ah.Color)or nil,
})

local aj

if typeof(ah.Color)=="table"then

aj=ac"UIGradient"
for ak,al in next,ah.Color do
aj[ak]=al
end

ai.TextColor3=GetTextColorForHSB(GetAverageColor(aj))
end



local ak=ab.NewRoundFrame(ah.Radius,"Squircle",{
AutomaticSize="X",
Size=UDim2.new(0,0,0,ah.Height),
Parent=ag,
ImageColor3=typeof(ah.Color)=="Color3"and ah.Color or Color3.new(1,1,1),
},{
aj,
ac("UIPadding",{
PaddingLeft=UDim.new(0,ah.Padding),
PaddingRight=UDim.new(0,ah.Padding),
}),
ai,
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
})
})


function ah.SetTitle(al,am)
ah.Title=am
ai.Text=am
end

function ah.SetColor(al,am)
ah.Color=am
if typeof(am)=="table"then
local an=GetAverageColor(am)
ad(ai,.06,{TextColor3=GetTextColorForHSB(an)}):Play()
local ao=ak:FindFirstChildOfClass"UIGradient"or ac("UIGradient",{Parent=ak})
for ap,aq in next,am do ao[ap]=aq end
ad(ak,.06,{ImageColor3=Color3.new(1,1,1)}):Play()
else
if aj then
aj:Destroy()
end
ad(ai,.06,{TextColor3=GetTextColorForHSB(am)}):Play()
ad(ak,.06,{ImageColor3=am}):Play()
end
end


return ah
end


return aa end function a.v()

local aa=game:GetService"HttpService"

local ab

local ac
ac={

Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(ad)
return{
__type=ad.__type,
value=ad.Default:ToHex(),
transparency=ad.Transparency or nil,
}
end,
Load=function(ad,ae)
if ad then
ad:Update(Color3.fromHex(ae.value),ae.transparency or nil)
end
end
},
Dropdown={
Save=function(ad)
return{
__type=ad.__type,
value=ad.Value,
}
end,
Load=function(ad,ae)
if ad then
ad:Select(ae.value)
end
end
},
Input={
Save=function(ad)
return{
__type=ad.__type,
value=ad.Value,
}
end,
Load=function(ad,ae)
if ad then
ad:Set(ae.value)
end
end
},
Keybind={
Save=function(ad)
return{
__type=ad.__type,
value=ad.Value,
}
end,
Load=function(ad,ae)
if ad then
ad:Set(ae.value)
end
end
},
Slider={
Save=function(ad)
return{
__type=ad.__type,
value=ad.Value.Default,
}
end,
Load=function(ad,ae)
if ad then
ad:Set(ae.value)
end
end
},
Toggle={
Save=function(ad)
return{
__type=ad.__type,
value=ad.Value,
}
end,
Load=function(ad,ae)
if ad then
ad:Set(ae.value)
end
end
},
}
}

function ac.Init(ad,ae)
if not ae.Folder then
warn"[ WindUI.ConfigManager ] Window.Folder is not specified."
return false
end

ab=ae
ac.Folder=ab.Folder
ac.Path="iHkazHub/"..tostring(ac.Folder).."/config/"

if not isfolder("iHkazHub/"..ac.Folder)then
makefolder("iHkazHub/"..ac.Folder)
if not isfolder("iHkazHub/"..ac.Folder.."/config/")then
makefolder("iHkazHub/"..ac.Folder.."/config/")
end
end

local af=ac:AllConfigs()

for ag,ah in next,af do
if isfile and readfile and isfile(ah..".json")then
ac.Configs[ah]=readfile(ah..".json")
end
end


return ac
end

function ac.CreateConfig(ad,ae)
local af={
Path=ac.Path..ae..".json",
Elements={},
CustomData={},
Version=1.1
}

if not ae then
return false,"No config file is selected"
end

function af.Register(ag,ah,ai)
af.Elements[ah]=ai
end

function af.Set(ag,ah,ai)
af.CustomData[ah]=ai
end

function af.Get(ag,ah)
return af.CustomData[ah]
end

function af.Save(ag)
local ah={
__version=af.Version,
__elements={},
__custom=af.CustomData
}

for ai,aj in next,af.Elements do
if ac.Parser[aj.__type]then
ah.__elements[tostring(ai)]=ac.Parser[aj.__type].Save(aj)
end
end

local ai=aa:JSONEncode(ah)
if writefile then
writefile(af.Path,ai)
end

return ah
end

function af.Load(ag)
if isfile and not isfile(af.Path)then
return false,"Config file does not exist"
end

local ah,ai=pcall(function()
local ah=readfile or function()warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."return nil end
return aa:JSONDecode(ah(af.Path))
end)

if not ah then
return false,"Failed to parse config file"
end

if not ai.__version then
local aj={
__version=af.Version,
__elements=ai,
__custom={}
}
ai=aj
end

for aj,ak in next,(ai.__elements or{})do
if af.Elements[aj]and ac.Parser[ak.__type]then
task.spawn(function()
ac.Parser[ak.__type].Load(af.Elements[aj],ak)
end)
end
end

af.CustomData=ai.__custom or{}

return af.CustomData
end

function af.GetData(ag)
return{
elements=af.Elements,
custom=af.CustomData
}
end

ac.Configs[ae]=af
return af
end

function ac.AllConfigs(ad)
if not listfiles then return{}end

local ae={}
if not isfolder(ac.Path)then
makefolder(ac.Path)
return ae
end

for af,ag in next,listfiles(ac.Path)do
local ah=ag:match"([^\\/]+)%.json$"
if ah then
table.insert(ae,ah)
end
end

return ae
end

function ac.GetConfig(ad,ae)
return ac.Configs[ae]
end

return ac end function a.w()

local aa={}

local ab=a.load'a'
local ac=ab.New
local ad=ab.Tween

game:GetService"UserInputService"


function aa.New(ae)
local af={
Button=nil
}

local ag=ac("TextLabel",{
Text=ae.Title,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
})


local ah=ac("Frame",{
Size=UDim2.new(0,36,0,36),
BackgroundTransparency=1,
Name="LogoArea",
},{
ac("ImageLabel",{
Image="rbxassetid://100253708538",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType=Enum.ScaleType.Crop,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
})
})


local ai=ac("Frame",{
Size=UDim2.new(0,1,1,0),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=.9,
})


local aj=ac("Frame",{
Size=UDim2.new(0,36,0,36),
BackgroundTransparency=1,
Name="Drag",
},{
ac("ImageLabel",{
Image=ab.Icon"vector-square"[1],
ImageRectOffset=ab.Icon"vector-square"[2].ImageRectPosition,
ImageRectSize=ab.Icon"vector-square"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.3,
})
})


local ak=ac("Frame",{
Size=UDim2.new(0,1,1,0),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=.9,
})

local al=ac("Frame",{
Size=UDim2.new(0,0,0,0),
Position=UDim2.new(0.5,0,0,28),
AnchorPoint=Vector2.new(0.5,0.5),
Parent=ae.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
})

local am=ac("TextButton",{
Size=UDim2.new(0,0,0,44),
AutomaticSize="X",
Parent=al,
Active=false,
BackgroundTransparency=.25,
ZIndex=99,
BackgroundColor3=Color3.new(0,0,0),
},{
ac("UICorner",{
CornerRadius=UDim.new(1,0)
}),
ac("UIStroke",{
Thickness=1,
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=0,
},{
ac("UIGradient",{
Color=ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff")
})
}),


ah,
ai,

ac("TextButton",{
AutomaticSize="XY",
Active=true,
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,36),
BackgroundColor3=Color3.new(1,1,1),
},{
ac("UICorner",{
CornerRadius=UDim.new(1,-4)
}),
ac("UIListLayout",{
Padding=UDim.new(0,ae.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ag,
ac("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
}),
}),

ak,
aj,

ac("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),

ac("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
})
})

af.Button=am


ab.AddSignal(am:GetPropertyChangedSignal"AbsoluteSize",function()
al.Size=UDim2.new(
0,am.AbsoluteSize.X,
0,am.AbsoluteSize.Y
)
end)

ab.AddSignal(am.TextButton.MouseEnter,function()
ad(am.TextButton,.1,{BackgroundTransparency=.93}):Play()
end)
ab.AddSignal(am.TextButton.MouseLeave,function()
ad(am.TextButton,.1,{BackgroundTransparency=1}):Play()
end)

local an=ab.Drag(al)


function af.Visible(ao,ap)
al.Visible=ap
end

function af.Edit(ao,ap)
local aq={
Title=ap.Title,
Enabled=ap.Enabled,
Position=ap.Position,
OnlyIcon=ap.OnlyIcon or false,
Draggable=ap.Draggable,
OnlyMobile=ap.OnlyMobile,
CornerRadius=ap.CornerRadius or UDim.new(1,0),
StrokeThickness=ap.StrokeThickness or 2,
Color=ap.Color
or ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff"),
}

if aq.Enabled==false then
ae.IsOpenButtonEnabled=false
end

if aq.OnlyMobile~=false then
aq.OnlyMobile=true
else
ae.IsPC=false
end


if aq.Draggable==false and aj and ak then
aj.Visible=aq.Draggable
ak.Visible=aq.Draggable

if an then
an:Set(aq.Draggable)
end
end

if aq.Position and al then
al.Position=aq.Position
end

if aq.OnlyIcon and ag then
ag.Visible=false
am.TextButton.UIPadding.PaddingLeft=UDim.new(0,7)
am.TextButton.UIPadding.PaddingRight=UDim.new(0,7)
end

if ag then
if aq.Title then
ag.Text=aq.Title
ab:ChangeTranslationKey(ag,aq.Title)
end
end

am.UIStroke.UIGradient.Color=aq.Color
if Glow then
Glow.UIGradient.Color=aq.Color
end

am.UICorner.CornerRadius=aq.CornerRadius
am.TextButton.UICorner.CornerRadius=UDim.new(aq.CornerRadius.Scale,aq.CornerRadius.Offset-4)
am.UIStroke.Thickness=aq.StrokeThickness
end

return af
end



return aa end function a.x()

local aa={}

local ab=a.load'a'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af)
local ag={
Container=nil,
ToolTipSize=16,
}

local ah=ac("TextLabel",{
AutomaticSize="XY",
TextWrapped=true,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
Text=ae,
TextSize=17,
TextTransparency=1,
ThemeTag={
TextColor3="Text",
}
})

local ai=ac("UIScale",{
Scale=.9
})

local aj=ac("Frame",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=af,

Visible=false
},{
ac("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
ac("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=false
},{
ac("ImageLabel",{
Size=UDim2.new(0,ag.ToolTipSize,0,ag.ToolTipSize/2),
BackgroundTransparency=1,
Rotation=180,
Image="rbxassetid://89524607682719",
ThemeTag={
ImageColor3="Accent",
},
},{
ac("ImageLabel",{
Size=UDim2.new(0,ag.ToolTipSize,0,ag.ToolTipSize/2),
BackgroundTransparency=1,
LayoutOrder=99,
ImageTransparency=.9,
Image="rbxassetid://89524607682719",
ThemeTag={
ImageColor3="Text",
},
}),
}),
}),
ab.NewRoundFrame(14,"Squircle",{
AutomaticSize="XY",
ThemeTag={
ImageColor3="Accent",
},
ImageTransparency=1,
Name="Background",
},{



ac("Frame",{
ThemeTag={
BackgroundColor3="Text",
},
AutomaticSize="XY",
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,16),
}),
ac("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

ah,
ac("UIPadding",{
PaddingTop=UDim.new(0,12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,12),
}),
})
}),
ai,
ac("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
ag.Container=aj

function ag.Open(ak)
aj.Visible=true


ad(aj.Background,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ah,.2,{TextTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ai,.18,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function ag.Close(ak)

ad(aj.Background,.3,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ah,.3,{TextTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ai,.35,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.35)

aj.Visible=false
aj:Destroy()
end

return ag
end



return aa end function a.y()
local aa=a.load'a'
local ab=aa.New
local ac=aa.NewRoundFrame
local ad=aa.Tween

game:GetService"UserInputService"


local function Color3ToHSB(ae)
local af,ag,ah=ae.R,ae.G,ae.B
local ai=math.max(af,ag,ah)
local aj=math.min(af,ag,ah)
local ak=ai-aj

local al=0
if ak~=0 then
if ai==af then
al=(ag-ah)/ak%6
elseif ai==ag then
al=(ah-af)/ak+2
else
al=(af-ag)/ak+4
end
al=al*60
else
al=0
end

local am=(ai==0)and 0 or(ak/ai)
local an=ai

return{
h=math.floor(al+0.5),
s=am,
b=an
}
end

local function GetPerceivedBrightness(ae)
local af=ae.R
local ag=ae.G
local ah=ae.B
return 0.299*af+0.587*ag+0.114*ah
end

local function GetTextColorForHSB(ae)
local af=Color3ToHSB(ae)local
ag, ah, ai=af.h, af.s, af.b
if GetPerceivedBrightness(ae)>0.5 then
return Color3.fromHSV(ag/360,0,0.05)
else
return Color3.fromHSV(ag/360,0,0.98)
end
end


local function getElementPosition(ae,af)
if type(af)~="number"or af~=math.floor(af)then
return nil,1
end






local ag=#ae


if ag==0 or af<1 or af>ag then
return nil,2
end

local function isDelimiter(ah)
if ah==nil then return true end
local ai=ah.__type
return ai=="Divider"or ai=="Space"or ai=="Section"or ai=="Code"
end

if isDelimiter(ae[af])then
return nil,3
end

local function calculate(ah,ai)
if ai==1 then return"Squircle"end
if ah==1 then return"Squircle-TL-TR"end
if ah==ai then return"Squircle-BL-BR"end
return"Square"
end

local ah=1
local ai=0

for aj=1,ag do
local ak=ae[aj]
if isDelimiter(ak)then
if af>=ah and af<=aj-1 then
local al=af-ah+1
return calculate(al,ai)
end
ah=aj+1
ai=0
else
ai=ai+1
end
end


if af>=ah and af<=ag then
local aj=af-ah+1
return calculate(aj,ai)
end

return nil,4
end


return function(ae)
local af={
Title=ae.Title,
Desc=ae.Desc or nil,
Hover=ae.Hover,
Thumbnail=ae.Thumbnail,
ThumbnailSize=ae.ThumbnailSize or 80,
Image=ae.Image,
IconThemed=ae.IconThemed or false,
ImageSize=ae.ImageSize or 30,
Color=ae.Color,
Scalable=ae.Scalable,
Parent=ae.Parent,
Justify=ae.Justify or"Between",
UIPadding=ae.Window.ElementConfig.UIPadding,
UICorner=ae.Window.ElementConfig.UICorner,
UIElements={},

Index=ae.Index
}

local ag=af.ImageSize
local ah=af.ThumbnailSize
local ai=true


local aj=0

local ak
local al
if af.Thumbnail then
ak=aa.Image(
af.Thumbnail,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Thumbnail",
false,
af.IconThemed
)
ak.Size=UDim2.new(1,0,0,ah)
end
if af.Image then
al=aa.Image(
af.Image,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Image",
not af.Color and true or false
)
if typeof(af.Color)=="string"then
al.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
elseif typeof(af.Color)=="Color3"then
al.ImageLabel.ImageColor3=GetTextColorForHSB(af.Color)
end

al.Size=UDim2.new(0,ag,0,ag)

aj=ag
end

local function CreateText(am,an)
local ao=typeof(af.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
or typeof(af.Color)=="Color3"
and GetTextColorForHSB(af.Color)

return ab("TextLabel",{
BackgroundTransparency=1,
Text=am or"",
TextSize=an=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not af.Color and"Text"or nil,
},
TextColor3=af.Color and ao or nil,
TextTransparency=an=="Desc"and.3 or 0,
TextWrapped=true,
Size=UDim2.new(af.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=af.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,an=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold)
})
end

local am=CreateText(af.Title,"Title")
local an=CreateText(af.Desc,"Desc")
if not af.Desc or af.Desc==""then
an.Visible=false
end

af.UIElements.Container=ab("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ab("UIListLayout",{
Padding=UDim.new(0,af.UIPadding),
FillDirection="Vertical",
VerticalAlignment=ae.Window.NewElements and"Top"or"Center",
HorizontalAlignment=af.Justify=="Between"and"Left"or"Center",
}),
ak,
ab("Frame",{
Size=UDim2.new(
af.Justify=="Between"and 1 or 0,
af.Justify=="Between"and-ae.TextOffset or 0,
0,
0
),
AutomaticSize=af.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="TitleFrame",
},{
ab("UIListLayout",{
Padding=UDim.new(0,af.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=ae.Window.NewElements and(af.Justify=="Between"and"Top"or"Center")or"Center",
HorizontalAlignment=af.Justify~="Between"and af.Justify or"Center",
}),
al,
ab("Frame",{
BackgroundTransparency=1,
AutomaticSize=af.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
af.Justify=="Between"and 1 or 0,
af.Justify=="Between"and(al and-aj-af.UIPadding or-aj)or 0,
1,
0
),
Name="TitleFrame",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,ae.Window.NewElements and af.UIPadding/2 or 0),
PaddingLeft=UDim.new(0,ae.Window.NewElements and af.UIPadding/2 or 0),
PaddingRight=UDim.new(0,ae.Window.NewElements and af.UIPadding/2 or 0),
PaddingBottom=UDim.new(0,ae.Window.NewElements and af.UIPadding/2 or 0),
}),
ab("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
am,
an
}),
})
})






local ao=aa.Image(
"lock",
"lock",
0,
ae.Window.Folder,
"Lock",
false
)
ao.Size=UDim2.new(0,20,0,20)
ao.ImageLabel.ImageColor3=Color3.new(1,1,1)
ao.ImageLabel.ImageTransparency=.4

local ap=ab("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=.05,
})

local aq=ab("Frame",{
Size=UDim2.new(1,af.UIPadding*2,1,af.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local ar,as=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=aq,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
ao,ap
},nil,true)

local at,au=ac(af.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aq,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local av,aw=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aq,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local ax,ay=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=af.Color and.05 or.93,



Parent=ae.Parent,
ThemeTag={
ImageColor3=not af.Color and"Text"or nil
},
ImageColor3=af.Color and
(
typeof(af.Color)=="string"
and Color3.fromHex(aa.Colors[af.Color])
or typeof(af.Color)=="Color3"
and af.Color
)or nil
},{
af.UIElements.Container,
aq,
ab("UIPadding",{
PaddingTop=UDim.new(0,af.UIPadding),
PaddingLeft=UDim.new(0,af.UIPadding),
PaddingRight=UDim.new(0,af.UIPadding),
PaddingBottom=UDim.new(0,af.UIPadding),
}),
},true,true)

af.UIElements.Main=ax
af.UIElements.Locked=ar

if af.Hover then
aa.AddSignal(ax.MouseEnter,function()
if ai then
ad(ax,.05,{ImageTransparency=af.Color and.15 or.9}):Play()
end
end)
aa.AddSignal(ax.InputEnded,function()
if ai then
ad(ax,.05,{ImageTransparency=af.Color and.05 or.93}):Play()
end
end)
end

function af.SetTitle(az,aA)
af.Title=aA
am.Text=aA
end

function af.SetDesc(az,aA)
af.Desc=aA
an.Text=aA or""
if not aA then
an.Visible=false
elseif not an.Visible then
an.Visible=true
end
end


function af.Colorize(az,aA,b)
if af.Color then
aA[b]=typeof(af.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
or typeof(af.Color)=="Color3"
and GetTextColorForHSB(af.Color)
or nil
end
end

if ae.ElementTable then
aa.AddSignal(am:GetPropertyChangedSignal"Text",function()
if af.Title~=am.Text then
af:SetTitle(am.Text)
ae.ElementTable.Title=am.Text
end
end)
aa.AddSignal(an:GetPropertyChangedSignal"Text",function()
if af.Desc~=an.Text then
af:SetDesc(an.Text)
ae.ElementTable.Desc=an.Text
end
end)
end





function af.SetThumbnail(az,aA,b)
af.Thumbnail=aA
if b then
af.ThumbnailSize=b
ah=b
end

if ak then
if aA then
ak:Destroy()
ak=aa.Image(
aA,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Thumbnail",
false,
af.IconThemed
)
ak.Size=UDim2.new(1,0,0,ah)
ak.Parent=af.UIElements.Container
local e=af.UIElements.Container:FindFirstChild"UIListLayout"
if e then
ak.LayoutOrder=-1
end
else
ak.Visible=false
end
else
if aA then
ak=aa.Image(
aA,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Thumbnail",
false,
af.IconThemed
)
ak.Size=UDim2.new(1,0,0,ah)
ak.Parent=af.UIElements.Container
local e=af.UIElements.Container:FindFirstChild"UIListLayout"
if e then
ak.LayoutOrder=-1
end
end
end
end

function af.SetImage(az,aA,b,e,g)
af.Image=aA
if b then
af.ImageSize=b
ag=b
end
if e~=nil then
af.Color=e
end
if g~=nil then
af.IconThemed=g
end

if al then
if aA then
al.Size=UDim2.new(0,ag,0,ag)
aa.UpdateImage(al,aA,af.Title)

if typeof(af.Color)=="string"then
al.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
elseif typeof(af.Color)=="Color3"then
al.ImageLabel.ImageColor3=GetTextColorForHSB(af.Color)
elseif not af.Color then
al.ImageLabel.ImageColor3=Color3.new(1,1,1)
end

al.Visible=true
aj=ag
else
al.Visible=false
aj=0
end
else
if aA then
al=aa.Image(
aA,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Image",
not af.Color and true or false
)

if typeof(af.Color)=="string"then
al.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
elseif typeof(af.Color)=="Color3"then
al.ImageLabel.ImageColor3=GetTextColorForHSB(af.Color)
end

al.Size=UDim2.new(0,ag,0,ag)
aj=ag

local h=af.UIElements.Container:FindFirstChild"Frame"
if h then
al.Parent=h
local i=h:FindFirstChild"UIListLayout"
if i then
al.LayoutOrder=0
end
end
end
end








end

function af.Destroy(az)
ax:Destroy()
end


function af.Lock(az)
ai=false
ar.Active=true
ar.Visible=true
end

function af.Unlock(az)
ai=true
ar.Active=false
ar.Visible=false
end

function af.Highlight(az)
local aA=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.1,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.9,0.9),
NumberSequenceKeypoint.new(1,1)
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=at
})

local b=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.15,0.8),
NumberSequenceKeypoint.new(0.5,0.1),
NumberSequenceKeypoint.new(0.85,0.8),
NumberSequenceKeypoint.new(1,1)
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=av
})

at.ImageTransparency=0.25
av.ImageTransparency=0.88

ad(aA,0.75,{
Offset=Vector2.new(1,0)
}):Play()

ad(b,0.75,{
Offset=Vector2.new(1,0)
}):Play()


task.spawn(function()
task.wait(.75)
at.ImageTransparency=1
av.ImageTransparency=1
aA:Destroy()
b:Destroy()
end)
end


function af.UpdateShape(az)
if ae.Window.NewElements then
local aA=getElementPosition(az.Elements,af.Index)
if aA and ax then
ay:SetType(aA)
as:SetType(aA)
aw:SetType(aA)
au:SetType(aA.."-Outline")
end
end
end





return af
end end function a.z()
local aa=a.load'a'
local ab=aa.New

local ac={}

local ad=a.load'i'.New

function ac.New(ae,af)
af.Hover=false
af.TextOffset=0
af.IsButtons=af.Buttons and#af.Buttons>0 and true or false

local ag={
__type="Paragraph",
Title=af.Title or"Paragraph",
Desc=af.Desc or nil,

Locked=af.Locked or false,
}
local ah=a.load'y'(af)

ag.ParagraphFrame=ah
if af.Buttons and#af.Buttons>0 then
local ai=ab("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ah.UIElements.Container
},{
ab("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
})
})


for aj,ak in next,af.Buttons do
local al=ad(ak.Title,ak.Icon,ak.Callback,"White",ai)
al.Size=UDim2.new(1,0,0,38)

end
end

return ag.__type,ag

end

return ac end function a.A()
local aa=a.load'a'local ab=
aa.New

local ac={}

function ac.New(ad,ae)
local af={
__type="Button",
Title=ae.Title or"Button",
Desc=ae.Desc or nil,
Icon=ae.Icon or"mouse-pointer-click",
IconThemed=ae.IconThemed or false,
Color=ae.Color,
Justify=ae.Justify or"Between",
IconAlign=ae.IconAlign or"Right",
Locked=ae.Locked or false,
Callback=ae.Callback or function()end,
UIElements={}
}

local ag=true

af.ButtonFrame=a.load'y'{
Title=af.Title,
Desc=af.Desc,
Parent=ae.Parent,




Window=ae.Window,
Color=af.Color,
Justify=af.Justify,
TextOffset=20,
Hover=true,
Scalable=true,
Tab=ae.Tab,
Index=ae.Index,
ElementTable=af,
}














af.UIElements.ButtonIcon=aa.Image(
af.Icon,
af.Icon,
0,
ae.Window.Folder,
"Button",
not af.Color and true or nil,
af.IconThemed
)

af.UIElements.ButtonIcon.Size=UDim2.new(0,20,0,20)
af.UIElements.ButtonIcon.Parent=af.Justify=="Between"and af.ButtonFrame.UIElements.Main or af.ButtonFrame.UIElements.Container.TitleFrame
af.UIElements.ButtonIcon.LayoutOrder=af.IconAlign=="Left"and-99999 or 99999
af.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
af.UIElements.ButtonIcon.Position=UDim2.new(1,0,0.5,0)

af.ButtonFrame:Colorize(af.UIElements.ButtonIcon.ImageLabel,"ImageColor3")

function af.Lock(ah)
af.Locked=true
ag=false
return af.ButtonFrame:Lock()
end
function af.Unlock(ah)
af.Locked=false
ag=true
return af.ButtonFrame:Unlock()
end

if af.Locked then
af:Lock()
end

aa.AddSignal(af.ButtonFrame.UIElements.Main.MouseButton1Click,function()
if ag then
task.spawn(function()
aa.SafeCallback(af.Callback)
end)
end
end)
return af.__type,af
end

return ac end function a.B()
local aa={}

local ab=a.load'a'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah)
local ai={}


local aj=13
local ak
if af and af~=""then
ak=ac("ImageLabel",{
Size=UDim2.new(1,-7,1,-7),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=ab.Icon(af)[1],
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
})
end

local al=ab.NewRoundFrame(aj,"Squircle",{
ImageTransparency=.93,
ThemeTag={
ImageColor3="Text"
},
Parent=ag,
Size=UDim2.new(0,41.6,0,26),
},{
ab.NewRoundFrame(aj,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Button",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(aj,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ac("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),


ab.NewRoundFrame(aj,"Squircle",{
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(0,3,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=0,
ImageColor3=Color3.new(1,1,1),



Name="Frame",
},{
ak,
})
})


function ai.Set(am,an,ao)
if an then
ad(al.Frame,0.15,{
Position=UDim2.new(1,-22,0.5,0),

},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al.Layer,0.1,{
ImageTransparency=0,
}):Play()
ad(al.Stroke,0.1,{
ImageTransparency=0.95,
}):Play()

if ak then
ad(ak,0.1,{
ImageTransparency=0,
}):Play()
end
else
ad(al.Frame,0.15,{
Position=UDim2.new(0,4,0.5,0),
Size=UDim2.new(0,18,0,18),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al.Layer,0.1,{
ImageTransparency=1,
}):Play()
ad(al.Stroke,0.1,{
ImageTransparency=1,
}):Play()

if ak then
ad(ak,0.1,{
ImageTransparency=1,
}):Play()
end
end

if ao~=false then ao=true end

task.spawn(function()
if ah and ao then
ab.SafeCallback(ah,an)
end
end)


end

return al,ai
end


return aa end function a.C()
local aa={}

local ab=a.load'a'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah)
local ai={}

af=af or"check"

local aj=10
local ak=ac("ImageLabel",{
Size=UDim2.new(1,-10,1,-10),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=ab.Icon(af)[1],
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(1,1,1),
})

local al=ab.NewRoundFrame(aj,"Squircle",{
ImageTransparency=.95,
ThemeTag={
ImageColor3="Text"
},
Parent=ag,
Size=UDim2.new(0,27,0,27),
},{
ab.NewRoundFrame(aj,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Button",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(aj,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ac("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),

ak,
})

function ai.Set(am,an)
if an then
ad(al.Layer,0.06,{
ImageTransparency=0,
}):Play()
ad(al.Stroke,0.06,{
ImageTransparency=0.95,
}):Play()
ad(ak,0.06,{
ImageTransparency=0,
}):Play()
else
ad(al.Layer,0.05,{
ImageTransparency=1,
}):Play()
ad(al.Stroke,0.05,{
ImageTransparency=1,
}):Play()
ad(ak,0.06,{
ImageTransparency=1,
}):Play()
end

task.spawn(function()
if ah then
ab.SafeCallback(ah,an)
end
end)
end

return al,ai
end


return aa end function a.D()
local aa=a.load'a'local ab=
aa.New local ac=
aa.Tween

local ad=a.load'B'.New
local ae=a.load'C'.New

local af={}

function af.New(ag,ah)
local ai={
__type="Toggle",
Title=ah.Title or"Toggle",
Desc=ah.Desc or nil,
Locked=ah.Locked or false,
Value=ah.Value,
Icon=ah.Icon or nil,
Type=ah.Type or"Toggle",
Callback=ah.Callback or function()end,
UIElements={}
}
ai.ToggleFrame=a.load'y'{
Title=ai.Title,
Desc=ai.Desc,




Window=ah.Window,
Parent=ah.Parent,
TextOffset=44,
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
ElementTable=ai,
}

local aj=true

if ai.Value==nil then
ai.Value=false
end



function ai.Lock(ak)
ai.Locked=true
aj=false
return ai.ToggleFrame:Lock()
end
function ai.Unlock(ak)
ai.Locked=false
aj=true
return ai.ToggleFrame:Unlock()
end

if ai.Locked then
ai:Lock()
end

local ak=ai.Value

local al,am
if ai.Type=="Toggle"then
al,am=ad(ak,ai.Icon,ai.ToggleFrame.UIElements.Main,ai.Callback)
elseif ai.Type=="Checkbox"then
al,am=ae(ak,ai.Icon,ai.ToggleFrame.UIElements.Main,ai.Callback)
else
error("Unknown Toggle Type: "..tostring(ai.Type))
end

al.AnchorPoint=Vector2.new(1,ah.Window.NewElements and 0 or 0.5)
al.Position=UDim2.new(1,0,ah.Window.NewElements and 0 or 0.5,0)

function ai.Set(an,ao,ap)
if aj then
am:Set(ao,ap)
ak=ao
ai.Value=ao
end
end

ai:Set(ak,false)

aa.AddSignal(ai.ToggleFrame.UIElements.Main.MouseButton1Click,function()
ai:Set(not ak)
end)

return ai.__type,ai
end

return af end function a.E()
local aa=a.load'a'
local ac=aa.New
local ad=aa.Tween

local ae={}

local af=false

function ae.New(ag,ah)
local ai={
__type="Slider",
Title=ah.Title or"Slider",
Desc=ah.Desc or nil,
Locked=ah.Locked or nil,
Value=ah.Value or{},
Step=ah.Step or 1,
Callback=ah.Callback or function()end,
UIElements={},
IsFocusing=false,

Width=130,
TextBoxWidth=30,
ThumbSize=13,
}
local aj
local ak
local al
local am=ai.Value.Default or ai.Value.Min or 0

local an=am
local ao=(am-(ai.Value.Min or 0))/((ai.Value.Max or 100)-(ai.Value.Min or 0))

local ap=true
local aq=ai.Step%1~=0

local function FormatValue(ar)
if aq then
return string.format("%.2f",ar)
else
return tostring(math.floor(ar+0.5))
end
end

local function CalculateValue(ar)
if aq then
return math.floor(ar/ai.Step+0.5)*ai.Step
else
return math.floor(ar/ai.Step+0.5)*ai.Step
end
end

ai.SliderFrame=a.load'y'{
Title=ai.Title,
Desc=ai.Desc,
Parent=ah.Parent,
TextOffset=ai.Width,
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
Window=ah.Window,
ElementTable=ai,
}

ai.UIElements.SliderIcon=aa.NewRoundFrame(99,"Squircle",{
ImageTransparency=.95,
Size=UDim2.new(1,-ai.TextBoxWidth-8,0,4),
Name="Frame",
ThemeTag={
ImageColor3="Text",
},
},{
aa.NewRoundFrame(99,"Squircle",{
Name="Frame",
Size=UDim2.new(ao,0,1,0),
ImageTransparency=.1,
ThemeTag={
ImageColor3="Button",
},
},{
aa.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,ai.ThumbSize,0,ai.ThumbSize),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Text",
},
Name="Thumb",
})
})
})

ai.UIElements.SliderContainer=ac("Frame",{
Size=UDim2.new(0,ai.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,0,.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Parent=ai.SliderFrame.UIElements.Main,
},{
ac("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai.UIElements.SliderIcon,
ac("TextBox",{
Size=UDim2.new(0,ai.TextBoxWidth,0,0),
TextXAlignment="Left",
Text=FormatValue(am),
ThemeTag={
TextColor3="Text"
},
TextTransparency=.4,
AutomaticSize="Y",
TextSize=15,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
LayoutOrder=-1,
})
})

function ai.Lock(ar)
ai.Locked=true
ap=false
return ai.SliderFrame:Lock()
end
function ai.Unlock(ar)
ai.Locked=false
ap=true
return ai.SliderFrame:Unlock()
end

if ai.Locked then
ai:Lock()
end

local ar=ai.SliderFrame.Parent:IsA"ScrollingFrame"and ai.SliderFrame.Parent or ai.SliderFrame.Parent.Parent.Parent

function ai.Set(as,at,au)
if ap then
if not ai.IsFocusing and not af and(not au or(au.UserInputType==Enum.UserInputType.MouseButton1 or au.UserInputType==Enum.UserInputType.Touch))then
at=math.clamp(at,ai.Value.Min or 0,ai.Value.Max or 100)

local av=math.clamp((at-(ai.Value.Min or 0))/((ai.Value.Max or 100)-(ai.Value.Min or 0)),0,1)
at=CalculateValue(ai.Value.Min+av*(ai.Value.Max-ai.Value.Min))

if at~=an then
ad(ai.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(av,0,1,0)}):Play()
ai.UIElements.SliderContainer.TextBox.Text=FormatValue(at)
ai.Value.Default=FormatValue(at)
an=at
aa.SafeCallback(ai.Callback,FormatValue(at))
end

if au then
aj=(au.UserInputType==Enum.UserInputType.Touch)
ar.ScrollingEnabled=false
af=true
ak=game:GetService"RunService".RenderStepped:Connect(function()
local aw=aj and au.Position.X or game:GetService"UserInputService":GetMouseLocation().X
local ax=math.clamp((aw-ai.UIElements.SliderIcon.AbsolutePosition.X)/ai.UIElements.SliderIcon.AbsoluteSize.X,0,1)
at=CalculateValue(ai.Value.Min+ax*(ai.Value.Max-ai.Value.Min))

if at~=an then
ad(ai.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(ax,0,1,0)}):Play()
ai.UIElements.SliderContainer.TextBox.Text=FormatValue(at)
ai.Value.Default=FormatValue(at)
an=at
aa.SafeCallback(ai.Callback,FormatValue(at))
end
end)
al=game:GetService"UserInputService".InputEnded:Connect(function(aw)
if(aw.UserInputType==Enum.UserInputType.MouseButton1 or aw.UserInputType==Enum.UserInputType.Touch)and au==aw then
ak:Disconnect()
al:Disconnect()
af=false
ar.ScrollingEnabled=true

ad(ai.UIElements.SliderIcon.Frame.Thumb,.12,{Size=UDim2.new(0,ai.ThumbSize,0,ai.ThumbSize)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end
end)
end
end
end
end

function ai.SetMax(as,at)
ai.Value.Max=at

local au=tonumber(ai.Value.Default)or an
if au>at then
ai:Set(at)
else
local av=math.clamp((au-(ai.Value.Min or 0))/(at-(ai.Value.Min or 0)),0,1)
ad(ai.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(av,0,1,0)}):Play()
end
end

function ai.SetMin(as,at)
ai.Value.Min=at

local au=tonumber(ai.Value.Default)or an
if au<at then
ai:Set(at)
else
local av=math.clamp((au-at)/((ai.Value.Max or 100)-at),0,1)
ad(ai.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(av,0,1,0)}):Play()
end
end

aa.AddSignal(ai.UIElements.SliderContainer.TextBox.FocusLost,function(as)
if as then
local at=tonumber(ai.UIElements.SliderContainer.TextBox.Text)
if at then
ai:Set(at)
else
ai.UIElements.SliderContainer.TextBox.Text=FormatValue(an)
end
end
end)

aa.AddSignal(ai.UIElements.SliderContainer.InputBegan,function(as)
ai:Set(am,as)

if as.UserInputType==Enum.UserInputType.MouseButton1 or as.UserInputType==Enum.UserInputType.Touch then
ad(ai.UIElements.SliderIcon.Frame.Thumb,.12,{Size=UDim2.new(0,ai.ThumbSize+8,0,ai.ThumbSize+8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)

return ai.__type,ai
end

return ae end function a.F()
local aa=game:GetService"UserInputService"

local ac=a.load'a'
local ad=ac.New local ae=
ac.Tween

local af={
UICorner=6,
UIPadding=8,
}

local ag=a.load's'.New

function af.New(ah,ai)
local aj={
__type="Keybind",
Title=ai.Title or"Keybind",
Desc=ai.Desc or nil,
Locked=ai.Locked or false,
Value=ai.Value or"F",
Callback=ai.Callback or function()end,
CanChange=ai.CanChange or true,
Picking=false,
UIElements={},
}

local ak=true

aj.KeybindFrame=a.load'y'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=85,
Hover=aj.CanChange,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
}

aj.UIElements.Keybind=ag(aj.Value,nil,aj.KeybindFrame.UIElements.Main)

aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
aj.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
aj.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

ad("UIScale",{
Parent=aj.UIElements.Keybind,
Scale=.85,
})

ac.AddSignal(aj.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

function aj.Lock(al)
aj.Locked=true
ak=false
return aj.KeybindtrueFrame:Lock()
end
function aj.Unlock(al)
aj.Locked=false
ak=true
return aj.KeybindFrame:Unlock()
end

function aj.Set(al,am)
aj.Value=am
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=am
end

if aj.Locked then
aj:Lock()
end

ac.AddSignal(aj.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if ak then
if aj.CanChange then
aj.Picking=true
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local al
al=aa.InputBegan:Connect(function(am)
local an

if am.UserInputType==Enum.UserInputType.Keyboard then
an=am.KeyCode.Name
elseif am.UserInputType==Enum.UserInputType.MouseButton1 then
an="MouseLeft"
elseif am.UserInputType==Enum.UserInputType.MouseButton2 then
an="MouseRight"
end

local ao
ao=aa.InputEnded:Connect(function(ap)
if ap.KeyCode.Name==an or an=="MouseLeft"and ap.UserInputType==Enum.UserInputType.MouseButton1 or an=="MouseRight"and ap.UserInputType==Enum.UserInputType.MouseButton2 then
aj.Picking=false

aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
aj.Value=an

al:Disconnect()
ao:Disconnect()
end
end)
end)
end
end
end)
ac.AddSignal(aa.InputBegan,function(al)
if ak then
if al.KeyCode.Name==aj.Value then
ac.SafeCallback(aj.Callback,al.KeyCode.Name)
end
end
end)
return aj.__type,aj
end

return af end function a.G()
local aa=a.load'a'
local ac=aa.New local ad=
aa.Tween

local ae={
UICorner=8,
UIPadding=8,
}local af=a.load'i'


.New
local ag=a.load'j'.New

function ae.New(ah,ai)
local aj={
__type="Input",
Title=ai.Title or"Input",
Desc=ai.Desc or nil,
Type=ai.Type or"Input",
Locked=ai.Locked or false,
InputIcon=ai.InputIcon or false,
Placeholder=ai.Placeholder or"Enter Text...",
Value=ai.Value or"",
Callback=ai.Callback or function()end,
ClearTextOnFocus=ai.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local ak=true

aj.InputFrame=a.load'y'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=aj.Width,
Hover=false,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
}

local al=ag(
aj.Placeholder,
aj.InputIcon,
aj.Type=="Textarea"and aj.InputFrame.UIElements.Container or aj.InputFrame.UIElements.Main,
aj.Type,
function(al)
aj:Set(al)
end,
nil,
ai.Window.NewElements and 12 or 10,
aj.ClearTextOnFocus
)

if aj.Type=="Input"then
al.Size=UDim2.new(0,aj.Width,0,36)
al.Position=UDim2.new(1,0,0.5,0)
al.AnchorPoint=Vector2.new(1,0.5)
else
al.Size=UDim2.new(1,0,0,148)
end

ac("UIScale",{
Parent=al,
Scale=1,
})

function aj.Lock(am)
aj.Locked=true
ak=false
return aj.InputFrame:Lock()
end
function aj.Unlock(am)
aj.Locked=false
ak=true
return aj.InputFrame:Unlock()
end


function aj.Set(am,an)
if ak then
aa.SafeCallback(aj.Callback,an)

al.Frame.Frame.TextBox.Text=an
aj.Value=an
end
end
function aj.SetPlaceholder(am,an)
al.Frame.Frame.TextBox.PlaceholderText=an
aj.Placeholder=an
end

aj:Set(aj.Value)

if aj.Locked then
aj:Lock()
end

return aj.__type,aj
end

return ae end function a.H()
local aa={}

local ac=game:GetService"UserInputService"
local ae=game:GetService"Players".LocalPlayer:GetMouse()
local af=game:GetService"Workspace".CurrentCamera

local ag=workspace.CurrentCamera

local ah=a.load'j'.New


local ai=a.load'a'
local aj=ai.New
local ak=ai.Tween

function aa.New(al,am,an,ao,ap)
local aq={}


am.UIElements.UIListLayout=aj("UIListLayout",{
Padding=UDim.new(0,an.MenuPadding),
FillDirection="Vertical"
})

am.UIElements.Menu=ai.NewRoundFrame(an.MenuCorner,"Squircle",{
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,an.MenuPadding),
PaddingLeft=UDim.new(0,an.MenuPadding),
PaddingRight=UDim.new(0,an.MenuPadding),
PaddingBottom=UDim.new(0,an.MenuPadding),
}),
aj("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,an.MenuPadding)
}),
aj("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,am.SearchBarEnabled and-an.MenuPadding-an.SearchBarHeight),

ClipsDescendants=true,
LayoutOrder=999,
},{
aj("UICorner",{
CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding),
}),
aj("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
am.UIElements.UIListLayout,
})
})
})

am.UIElements.MenuCanvas=aj("Frame",{
Size=UDim2.new(0,am.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,

Parent=al.WindUI.DropdownGui,
AnchorPoint=Vector2.new(1,0),
},{
am.UIElements.Menu,






aj("UISizeConstraint",{
MinSize=Vector2.new(170,0)
})
})



local function RecalculateCanvasSize()
am.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=UDim2.fromOffset(0,am.UIElements.UIListLayout.AbsoluteContentSize.Y)

end

local function RecalculateListSize()
local ar=ag.ViewportSize.Y*0.6

local as=am.UIElements.UIListLayout.AbsoluteContentSize.Y
local at=am.SearchBarEnabled and(an.SearchBarHeight+(an.MenuPadding*3))or(an.MenuPadding*2)
local au=(as)+at

if au>ar then
am.UIElements.MenuCanvas.Size=UDim2.fromOffset(
am.UIElements.MenuCanvas.AbsoluteSize.X,
ar
)
else
am.UIElements.MenuCanvas.Size=UDim2.fromOffset(
am.UIElements.MenuCanvas.AbsoluteSize.X,
au
)
end
end

function UpdatePosition()
local ar=am.UIElements.Dropdown
local as=am.UIElements.MenuCanvas

local at=af.ViewportSize.Y-(ar.AbsolutePosition.Y+ar.AbsoluteSize.Y)-an.MenuPadding-54
local au=as.AbsoluteSize.Y+an.MenuPadding

local av=-54
if at<au then
av=au-at-54
end

as.Position=UDim2.new(
0,
ar.AbsolutePosition.X+ar.AbsoluteSize.X,
0,
ar.AbsolutePosition.Y+ar.AbsoluteSize.Y-av+an.MenuPadding
)
end

local ar


function aq.Display(as)
local at=am.Values
local au=""

if am.Multi then
for av,aw in next,at do
local ax=typeof(aw)=="table"and aw.Title or aw
if table.find(am.Value,ax)then
au=au..ax..", "
end
end
au=au:sub(1,#au-2)
else
au=typeof(am.Value)=="table"and am.Value.Title or am.Value or""
end

am.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(au==""and"--"or au)
end

function aq.Refresh(as,at)
for au,av in next,am.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
if not av:IsA"UIListLayout"then
av:Destroy()
end
end

am.Tabs={}

if am.SearchBarEnabled then
if not ar then
ar=ah("Search...","search",am.UIElements.Menu,nil,function(au)
for av,aw in next,am.Tabs do
if string.find(string.lower(aw.Name),string.lower(au),1,true)then
aw.UIElements.TabItem.Visible=true
else
aw.UIElements.TabItem.Visible=false
end
RecalculateListSize()
end
end,true)
ar.Size=UDim2.new(1,0,0,an.SearchBarHeight)
ar.Position=UDim2.new(0,0,0,0)
ar.Name="SearchBar"
end
end

for au,av in next,at do

local aw={
Name=typeof(av)=="table"and av.Title or av,
Icon=typeof(av)=="table"and av.Icon or nil,
Original=av,
Selected=false,
UIElements={},
}
local ax
if aw.Icon then
ax=ai.Image(
aw.Icon,
aw.Icon,
0,
al.Window.Folder,
"Dropdown",
true
)
ax.Size=UDim2.new(0,an.TabIcon,0,an.TabIcon)
ax.ImageLabel.ImageTransparency=.2
aw.UIElements.TabIcon=ax
end
aw.UIElements.TabItem=ai.NewRoundFrame(an.MenuCorner-an.MenuPadding,"Squircle",{
Size=UDim2.new(1,0,0,36),

ImageTransparency=1,
Parent=am.UIElements.Menu.Frame.ScrollingFrame,

ImageColor3=Color3.new(1,1,1),

},{
ai.NewRoundFrame(an.MenuCorner-an.MenuPadding,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
Name="Highlight",
},{
aj("UIGradient",{
Rotation=80,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
aj("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
aj("UIListLayout",{
Padding=UDim.new(0,an.TabPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj("UIPadding",{

PaddingLeft=UDim.new(0,an.TabPadding),
PaddingRight=UDim.new(0,an.TabPadding),

}),
aj("UICorner",{
CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding)
}),













ax,
aj("TextLabel",{
Text=aw.Name,
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text"
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=.4,
LayoutOrder=999,
AutomaticSize="Y",

Size=UDim2.new(1,ax and-an.TabPadding-an.TabIcon or 0,0,0),
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
})
})
},true)


if am.Multi then
aw.Selected=table.find(am.Value or{},aw.Name)
else
aw.Selected=typeof(am.Value)=="table"and am.Value.Title==aw.Name
or am.Value==aw.Name
end

if aw.Selected then
aw.UIElements.TabItem.ImageTransparency=.95
aw.UIElements.TabItem.Highlight.ImageTransparency=.75


aw.UIElements.TabItem.Frame.TextLabel.TextTransparency=0
if aw.UIElements.TabIcon then
aw.UIElements.TabIcon.ImageLabel.ImageTransparency=0
end
end

am.Tabs[au]=aw

aq:Display()

local function Callback()
aq:Display()
task.spawn(function()
ai.SafeCallback(am.Callback,am.Value)
end)
end


ai.AddSignal(aw.UIElements.TabItem.MouseButton1Click,function()
if ap=="Dropdown"then
if am.Multi then
if not aw.Selected then
aw.Selected=true
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()

ak(aw.UIElements.TabItem.Frame.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
table.insert(am.Value,aw.Original)
else
if not am.AllowNone and#am.Value==1 then
return
end
aw.Selected=false
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()

ak(aw.UIElements.TabItem.Frame.TextLabel,0.1,{TextTransparency=.4}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()
end

for ay,az in ipairs(am.Value)do
if typeof(az)=="table"and(az.Title==aw.Name)or(az==aw.Name)then
table.remove(am.Value,ay)
break
end
end
end
else
for ay,az in next,am.Tabs do

ak(az.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(az.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()

ak(az.UIElements.TabItem.Frame.TextLabel,0.1,{TextTransparency=.4}):Play()
if az.UIElements.TabIcon then
ak(az.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()
end
az.Selected=false
end
aw.Selected=true
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()

ak(aw.UIElements.TabItem.Frame.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
am.Value=aw.Original
end
Callback()
end
end)

RecalculateCanvasSize()
RecalculateListSize()
end

local au=0
for av,aw in next,am.Tabs do
if aw.UIElements.TabItem.Frame.TextLabel then

local ax=aw.UIElements.TabItem.Frame.TextLabel.TextBounds.X
au=math.max(au,ax)
end
end

am.UIElements.MenuCanvas.Size=UDim2.new(0,au+6+6+5+5+18+6+6,am.UIElements.MenuCanvas.Size.Y.Scale,am.UIElements.MenuCanvas.Size.Y.Offset)


end


aq:Refresh(am.Values)

function aq.Select(as,at)
if at then
am.Value=at
else
if am.Multi then
am.Value={}
else
am.Value=nil

end
end
aq:Refresh(am.Values)
end






RecalculateListSize()

function aq.Open(as)
if ao then
am.UIElements.Menu.Visible=true
am.UIElements.MenuCanvas.Visible=true
am.UIElements.MenuCanvas.Active=true
am.UIElements.Menu.Size=UDim2.new(
1,0,
0,0
)
ak(am.UIElements.Menu,0.1,{
Size=UDim2.new(
1,0,
1,0
),
ImageTransparency=0.05
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(.1)
am.Opened=true
end)




UpdatePosition()
end
end
function aq.Close(as)
am.Opened=false

ak(am.UIElements.Menu,0.25,{
Size=UDim2.new(
1,0,
0,0
),
ImageTransparency=1,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()


task.spawn(function()
task.wait(.1)
am.UIElements.Menu.Visible=false
end)

task.spawn(function()
task.wait(.25)
am.UIElements.MenuCanvas.Visible=false
am.UIElements.MenuCanvas.Active=false
end)
end

ai.AddSignal(am.UIElements.Dropdown.MouseButton1Click,function()
aq:Open()
end)

ai.AddSignal(ac.InputBegan,function(as)
if as.UserInputType==Enum.UserInputType.MouseButton1 or as.UserInputType==Enum.UserInputType.Touch then
local at=am.UIElements.MenuCanvas
local au,av=at.AbsolutePosition,at.AbsoluteSize

local aw=am.UIElements.Dropdown
local ax=aw.AbsolutePosition
local ay=aw.AbsoluteSize

local az=
ae.X>=ax.X and
ae.X<=ax.X+ay.X and
ae.Y>=ax.Y and
ae.Y<=ax.Y+ay.Y

local aA=
ae.X>=au.X and
ae.X<=au.X+av.X and
ae.Y>=au.Y and
ae.Y<=au.Y+av.Y

if al.Window.CanDropdown and am.Opened and not az and not aA then
aq:Close()
end
end
end)

ai.AddSignal(am.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition",UpdatePosition)


return aq
end


return aa end function a.I()
game:GetService"UserInputService"
game:GetService"Players".LocalPlayer:GetMouse()local aa=
game:GetService"Workspace".CurrentCamera

local ac=a.load'a'
local ae=ac.New local af=
ac.Tween

local ag=a.load's'.New local ah=a.load'j'
.New
local ai=a.load'H'.New local aj=

workspace.CurrentCamera

local ak={
UICorner=10,
UIPadding=12,
MenuCorner=15,
MenuPadding=5,
TabPadding=10,
SearchBarHeight=39,
TabIcon=18,
}

function ak.New(al,am)
local an={
__type="Dropdown",
Title=am.Title or"Dropdown",
Desc=am.Desc or nil,
Locked=am.Locked or false,
Values=am.Values or{},
MenuWidth=am.MenuWidth or 170,
Value=am.Value,
AllowNone=am.AllowNone,
SearchBarEnabled=am.SearchBarEnabled or false,
Multi=am.Multi,
Callback=am.Callback or function()end,

UIElements={},

Opened=false,
Tabs={},

Width=150,
}

if an.Multi and not an.Value then
an.Value={}
end

local ao=true

an.DropdownFrame=a.load'y'{
Title=an.Title,
Desc=an.Desc,
Parent=am.Parent,
TextOffset=an.Width,
Hover=false,
Tab=am.Tab,
Index=am.Index,
Window=am.Window,
ElementTable=an,
}


an.UIElements.Dropdown=ag("",nil,an.DropdownFrame.UIElements.Main)

an.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
an.UIElements.Dropdown.Frame.Frame.TextLabel.Size=UDim2.new(1,an.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

an.UIElements.Dropdown.Size=UDim2.new(0,an.Width,0,36)
an.UIElements.Dropdown.Position=UDim2.new(1,0,0.5,0)
an.UIElements.Dropdown.AnchorPoint=Vector2.new(1,0.5)






ae("ImageLabel",{
Image=ac.Icon"chevrons-up-down"[1],
ImageRectOffset=ac.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=ac.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,-12,0.5,0),
ThemeTag={
ImageColor3="Icon"
},
AnchorPoint=Vector2.new(1,0.5),
Parent=an.UIElements.Dropdown.Frame
})


an.DropdownMenu=ai(am,an,ak,ao,"Dropdown")

an.Display=an.DropdownMenu.Display
an.Refresh=an.DropdownMenu.Refresh
an.Select=an.DropdownMenu.Select
an.Open=an.DropdownMenu.Open
an.Close=an.DropdownMenu.Close

function an.Lock(ap)
an.Locked=true
ao=false
return an.DropdownFrame:Lock()
end
function an.Unlock(ap)
an.Locked=false
ao=true
return an.DropdownFrame:Unlock()
end

if an.Locked then
an:Lock()
end


return an.__type,an
end

return ak end function a.J()






local ac={}
local ae={
lua={
"and","break","or","else","elseif","if","then","until","repeat","while","do","for","in","end",
"local","return","function","export",
},
rbx={
"game","workspace","script","math","string","table","task","wait","select","next","Enum",
"tick","assert","shared","loadstring","tonumber","tostring","type",
"typeof","unpack","Instance","CFrame","Vector3","Vector2","Color3","UDim","UDim2","Ray","BrickColor",
"OverlapParams","RaycastParams","Axes","Random","Region3","Rect","TweenInfo",
"collectgarbage","not","utf8","pcall","xpcall","_G","setmetatable","getmetatable","os","pairs","ipairs"
},
operators={
"#","+","-","*","%","/","^","=","~","=","<",">",
}
}

local ag={
numbers=Color3.fromHex"#FAB387",
boolean=Color3.fromHex"#FAB387",
operator=Color3.fromHex"#94E2D5",
lua=Color3.fromHex"#CBA6F7",
rbx=Color3.fromHex"#F38BA8",
str=Color3.fromHex"#A6E3A1",
comment=Color3.fromHex"#9399B2",
null=Color3.fromHex"#F38BA8",
call=Color3.fromHex"#89B4FA",
self_call=Color3.fromHex"#89B4FA",
local_property=Color3.fromHex"#CBA6F7",
}

local function createKeywordSet(ai)
local aj={}
for ak,al in ipairs(ai)do
aj[al]=true
end
return aj
end

local ai=createKeywordSet(ae.lua)
local aj=createKeywordSet(ae.rbx)
local ak=createKeywordSet(ae.operators)

local function getHighlight(al,am)
local an=al[am]

if ag[an.."_color"]then
return ag[an.."_color"]
end

if tonumber(an)then
return ag.numbers
elseif an=="nil"then
return ag.null
elseif an:sub(1,2)=="--"then
return ag.comment
elseif ak[an]then
return ag.operator
elseif ai[an]then
return ag.lua
elseif aj[an]then
return ag.rbx
elseif an:sub(1,1)=="\""or an:sub(1,1)=="\'"then
return ag.str
elseif an=="true"or an=="false"then
return ag.boolean
end

if al[am+1]=="("then
if al[am-1]==":"then
return ag.self_call
end

return ag.call
end

if al[am-1]=="."then
if al[am-2]=="Enum"then
return ag.rbx
end

return ag.local_property
end
end

function ac.run(al)
local am={}
local an=""

local ao=false
local ap=false
local aq=false

for ar=1,#al do
local as=al:sub(ar,ar)

if ap then
if as=="\n"and not aq then
table.insert(am,an)
table.insert(am,as)
an=""

ap=false
elseif al:sub(ar-1,ar)=="]]"and aq then
an=an.."]"

table.insert(am,an)
an=""

ap=false
aq=false
else
an=an..as
end
elseif ao then
if as==ao and al:sub(ar-1,ar-1)~="\\"or as=="\n"then
an=an..as
ao=false
else
an=an..as
end
else
if al:sub(ar,ar+1)=="--"then
table.insert(am,an)
an="-"
ap=true
aq=al:sub(ar+2,ar+3)=="[["
elseif as=="\""or as=="\'"then
table.insert(am,an)
an=as
ao=as
elseif ak[as]then
table.insert(am,an)
table.insert(am,as)
an=""
elseif as:match"[%w_]"then
an=an..as
else
table.insert(am,an)
table.insert(am,as)
an=""
end
end
end

table.insert(am,an)

local ar={}

for as,at in ipairs(am)do
local au=getHighlight(am,as)

if au then
local av=string.format("<font color = \"#%s\">%s</font>",au:ToHex(),at:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(ar,av)
else
table.insert(ar,at)
end
end

return table.concat(ar)
end

return ac end function a.K()
local ac={}

local ae=a.load'a'
local ag=ae.New
local ai=ae.Tween

local aj=a.load'J'

function ac.New(ak,al,am,an,ao)
local ap={
Radius=12,
Padding=10
}

local aq=ag("TextLabel",{
Text="",
TextColor3=Color3.fromHex"#CDD6F4",
TextTransparency=0,
TextSize=14,
TextWrapped=false,
LineHeight=1.15,
RichText=true,
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ag("UIPadding",{
PaddingTop=UDim.new(0,ap.Padding+3),
PaddingLeft=UDim.new(0,ap.Padding+3),
PaddingRight=UDim.new(0,ap.Padding+3),
PaddingBottom=UDim.new(0,ap.Padding+3),
})
})
aq.Font="Code"

local ar=ag("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
aq
})

local as=ag("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,30,0,30),
Position=UDim2.new(1,-ap.Padding/2,0,ap.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=an and true or false,
},{
ae.NewRoundFrame(ap.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
ag("UIScale",{
Scale=1,
}),
ag("ImageLabel",{
Image=ae.Icon"copy"[1],
ImageRectSize=ae.Icon"copy"[2].ImageRectSize,
ImageRectOffset=ae.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.1,
})
})
})

ae.AddSignal(as.MouseEnter,function()
ai(as.Button,.05,{ImageTransparency=.95}):Play()
ai(as.Button.UIScale,.05,{Scale=.9}):Play()
end)
ae.AddSignal(as.InputEnded,function()
ai(as.Button,.08,{ImageTransparency=1}):Play()
ai(as.Button.UIScale,.08,{Scale=1}):Play()
end)

local at=ae.NewRoundFrame(ap.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=.035,
Size=UDim2.new(1,0,0,20+(ap.Padding*2)),
AutomaticSize="Y",
Parent=am,
},{
ae.NewRoundFrame(ap.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.955,
}),
ag("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
},{
ae.NewRoundFrame(ap.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.96,
Size=UDim2.new(1,0,0,20+(ap.Padding*2)),
Visible=al and true or false
},{
ag("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://132464694294269",



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.2,
}),
ag("TextLabel",{
Text=al,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=.2,
TextSize=16,
AutomaticSize="Y",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,as and-20-(ap.Padding*2),0,0)
}),
ag("UIPadding",{

PaddingLeft=UDim.new(0,ap.Padding+3),
PaddingRight=UDim.new(0,ap.Padding+3),

}),
ag("UIListLayout",{
Padding=UDim.new(0,ap.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
ar,
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
as,
})

ap.CodeFrame=at

ae.AddSignal(aq:GetPropertyChangedSignal"TextBounds",function()
ar.Size=UDim2.new(1,0,0,(aq.TextBounds.Y/(ao or 1))+((ap.Padding+3)*2))
end)

function ap.Set(au)
aq.Text=aj.run(au)
end

function ap.Destroy()
at:Destroy()
ap=nil
end

ap.Set(ak)

ae.AddSignal(as.MouseButton1Click,function()
if an then
an()
local au=ae.Icon"check"
as.Button.ImageLabel.Image=au[1]
as.Button.ImageLabel.ImageRectSize=au[2].ImageRectSize
as.Button.ImageLabel.ImageRectOffset=au[2].ImageRectPosition

task.wait(1)
local av=ae.Icon"copy"
as.Button.ImageLabel.Image=av[1]
as.Button.ImageLabel.ImageRectSize=av[2].ImageRectSize
as.Button.ImageLabel.ImageRectOffset=av[2].ImageRectPosition
end
end)
return ap
end


return ac end function a.L()
local ac=a.load'a'local ae=
ac.New


local ag=a.load'K'

local ai={}

function ai.New(aj,ak)
local al={
__type="Code",
Title=ak.Title,
Code=ak.Code,
OnCopy=ak.OnCopy,
}

local am=not al.Locked











local an=ag.New(al.Code,al.Title,ak.Parent,function()
if am then
local an=al.Title or"code"
local ao,ap=pcall(function()
toclipboard(al.Code)

if al.OnCopy then al.OnCopy()end
end)
if not ao then
ak.WindUI:Notify{
Title="Error",
Content="The "..an.." is not copied. Error: "..ap,
Icon="x",
Duration=5,
}
end
end
end,ak.WindUI.UIScale,al)

function al.SetCode(ao,ap)
an.Set(ap)
end

function al.Destroy(ao)
an.Destroy()
al=nil
end

al.ElementFrame=an.CodeFrame

return al.__type,al
end

return ai end function a.M()
local ac=a.load'a'
local ae=ac.New local ag=
ac.Tween

local ai=game:GetService"UserInputService"
game:GetService"TouchInputService"
local aj=game:GetService"RunService"
local ak=game:GetService"Players"

local al=aj.RenderStepped
local am=ak.LocalPlayer
local an=am:GetMouse()

local ao=a.load'i'.New
local ap=a.load'j'.New

local aq={
UICorner=8,
UIPadding=8
}

function aq.Colorpicker(ar,as,at,au)
local av={
__type="Colorpicker",
Title=as.Title,
Desc=as.Desc,
Default=as.Default,
Callback=as.Callback,
Transparency=as.Transparency,
UIElements=as.UIElements,

TextPadding=10,
}

function av.SetHSVFromRGB(aw,ax)
local ay,az,aA=Color3.toHSV(ax)
av.Hue=ay
av.Sat=az
av.Vib=aA
end

av:SetHSVFromRGB(av.Default)

local aw=a.load'k'.Init(at)
local ax=aw.Create()

av.ColorpickerFrame=ax

ax.UIElements.Main.Size=UDim2.new(1,0,0,0)



local ay,az,aA=av.Hue,av.Sat,av.Vib

av.UIElements.Title=ae("TextLabel",{
Text=av.Title,
TextSize=20,
FontFace=Font.new(ac.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=ax.UIElements.Main
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,av.TextPadding/2),
PaddingLeft=UDim.new(0,av.TextPadding/2),
PaddingRight=UDim.new(0,av.TextPadding/2),
PaddingBottom=UDim.new(0,av.TextPadding/2),
})
})





local b=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=HueDragHolder,
BackgroundColor3=av.Default
},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

av.UIElements.SatVibMap=ae("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+av.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(ay,1,1),
BackgroundTransparency=0,
Parent=ax.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
ac.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ae("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),

b,
})

av.UIElements.Inputs=ae("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(av.Transparency and 240 or 210,40+av.TextPadding),
BackgroundTransparency=1,
Parent=ax.UIElements.Main
},{
ae("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
})
})





local e=ae("Frame",{
BackgroundColor3=av.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=av.Transparency,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ae("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+av.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ax.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
ac.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ae("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),







e,
})

local g=ae("Frame",{
BackgroundColor3=av.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ae("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+av.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ax.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),







ac.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ae("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),
g,
})

local h={}

for i=0,1,0.1 do
table.insert(h,ColorSequenceKeypoint.new(i,Color3.fromHSV(i,1,1)))
end

local i=ae("UIGradient",{
Color=ColorSequence.new(h),
Rotation=90,
})

local j=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local l=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=j,


BackgroundColor3=av.Default
},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

local m=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+av.TextPadding),
Parent=ax.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
i,
j,
})


function CreateNewInput(p,r)
local u=ap(p,nil,av.UIElements.Inputs)

ae("TextLabel",{
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=17,
FontFace=Font.new(ac.Font,Enum.FontWeight.Regular),
AutomaticSize="XY",
ThemeTag={
TextColor3="Placeholder",
},
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Parent=u.Frame,
Text=p,
})

ae("UIScale",{
Parent=u,
Scale=.85,
})

u.Frame.Frame.TextBox.Text=r
u.Size=UDim2.new(0,150,0,42)

return u
end

local function ToRGB(p)
return{
R=math.floor(p.R*255),
G=math.floor(p.G*255),
B=math.floor(p.B*255)
}
end

local p=CreateNewInput("Hex","#"..av.Default:ToHex())

local r=CreateNewInput("Red",ToRGB(av.Default).R)
local u=CreateNewInput("Green",ToRGB(av.Default).G)
local v=CreateNewInput("Blue",ToRGB(av.Default).B)
local x
if av.Transparency then
x=CreateNewInput("Alpha",((1-av.Transparency)*100).."%")
end

local z=ae("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+av.TextPadding),
BackgroundTransparency=1,
Parent=ax.UIElements.Main,
LayoutOrder=4,
},{
ae("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

local A={
{
Title="Cancel",
Variant="Secondary",
Callback=function()end
},
{
Title="Apply",
Icon="chevron-right",
Variant="Primary",
Callback=function()au(Color3.fromHSV(av.Hue,av.Sat,av.Vib),av.Transparency)end
}
}

for B,C in next,A do
local F=ao(C.Title,C.Icon,C.Callback,C.Variant,z,ax,false)
F.Size=UDim2.new(0.5,-3,0,40)
F.AutomaticSize="None"
end



local B,C,F
if av.Transparency then
local G=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

C=ae("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=G,

},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})

})

F=ae("Frame",{
Size=UDim2.fromScale(1,1),
},{
ae("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
ae("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

B=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+av.TextPadding),
Parent=ax.UIElements.Main,
BackgroundTransparency=1,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
ae("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
F,
G,
})
end

function av.Round(G,H,J)
if J==0 then
return math.floor(H)
end
H=tostring(H)
return H:find"%."and tonumber(H:sub(1,H:find"%."+J))or H
end


function av.Update(G,H,J)
if H then ay,az,aA=Color3.toHSV(H)else ay,az,aA=av.Hue,av.Sat,av.Vib end

av.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(ay,1,1)
b.Position=UDim2.new(az,0,1-aA,0)
b.BackgroundColor3=Color3.fromHSV(ay,az,aA)
g.BackgroundColor3=Color3.fromHSV(ay,az,aA)
l.BackgroundColor3=Color3.fromHSV(ay,1,1)
l.Position=UDim2.new(0.5,0,ay,0)

p.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(ay,az,aA):ToHex()
r.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).R
u.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).G
v.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).B

if J or av.Transparency then
g.BackgroundTransparency=av.Transparency or J
F.BackgroundColor3=Color3.fromHSV(ay,az,aA)
C.BackgroundColor3=Color3.fromHSV(ay,az,aA)
C.BackgroundTransparency=av.Transparency or J
C.Position=UDim2.new(0.5,0,1-av.Transparency or J,0)
x.Frame.Frame.TextBox.Text=av:Round((1-av.Transparency or J)*100,0).."%"
end
end

av:Update(av.Default,av.Transparency)




local function GetRGB()
local G=Color3.fromHSV(av.Hue,av.Sat,av.Vib)
return{R=math.floor(G.r*255),G=math.floor(G.g*255),B=math.floor(G.b*255)}
end



local function clamp(G,H,J)
return math.clamp(tonumber(G)or 0,H,J)
end

ac.AddSignal(p.Frame.Frame.TextBox.FocusLost,function(G)
if G then
local H=p.Frame.Frame.TextBox.Text:gsub("#","")
local J,L=pcall(Color3.fromHex,H)
if J and typeof(L)=="Color3"then
av.Hue,av.Sat,av.Vib=Color3.toHSV(L)
av:Update()
av.Default=L
end
end
end)

local function updateColorFromInput(G,H)
ac.AddSignal(G.Frame.Frame.TextBox.FocusLost,function(J)
if J then
local L=G.Frame.Frame.TextBox
local M=GetRGB()
local N=clamp(L.Text,0,255)
L.Text=tostring(N)

M[H]=N
local O=Color3.fromRGB(M.R,M.G,M.B)
av.Hue,av.Sat,av.Vib=Color3.toHSV(O)
av:Update()
end
end)
end

updateColorFromInput(r,"R")
updateColorFromInput(u,"G")
updateColorFromInput(v,"B")

if av.Transparency then
ac.AddSignal(x.Frame.Frame.TextBox.FocusLost,function(G)
if G then
local H=x.Frame.Frame.TextBox
local J=clamp(H.Text,0,100)
H.Text=tostring(J)

av.Transparency=1-J*0.01
av:Update(nil,av.Transparency)
end
end)
end



local G=av.UIElements.SatVibMap
ac.AddSignal(G.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=G.AbsolutePosition.X
local L=J+G.AbsoluteSize.X
local M=math.clamp(an.X,J,L)

local N=G.AbsolutePosition.Y
local O=N+G.AbsoluteSize.Y
local P=math.clamp(an.Y,N,O)

av.Sat=(M-J)/(L-J)
av.Vib=1-((P-N)/(O-N))
av:Update()

al:Wait()
end
end
end)

ac.AddSignal(m.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=m.AbsolutePosition.Y
local L=J+m.AbsoluteSize.Y
local M=math.clamp(an.Y,J,L)

av.Hue=((M-J)/(L-J))
av:Update()

al:Wait()
end
end
end)

if av.Transparency then
ac.AddSignal(B.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=B.AbsolutePosition.Y
local L=J+B.AbsoluteSize.Y
local M=math.clamp(an.Y,J,L)

av.Transparency=1-((M-J)/(L-J))
av:Update()

al:Wait()
end
end
end)
end

return av
end

function aq.New(ar,as)
local at={
__type="Colorpicker",
Title=as.Title or"Colorpicker",
Desc=as.Desc or nil,
Locked=as.Locked or false,
Default=as.Default or Color3.new(1,1,1),
Callback=as.Callback or function()end,

UIScale=as.UIScale,
Transparency=as.Transparency,
UIElements={}
}

local au=true

if as.Window.NewElements then aq.UICorner=14 end

at.ColorpickerFrame=a.load'y'{
Title=at.Title,
Desc=at.Desc,
Parent=as.Parent,
TextOffset=40,
Hover=false,
Tab=as.Tab,
Index=as.Index,
Window=as.Window,
ElementTable=at,
}

at.UIElements.Colorpicker=ac.NewRoundFrame(aq.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=at.Default,
Parent=at.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,30,0,30),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2
},nil,true)


function at.Lock(av)
at.Locked=true
au=false
return at.ColorpickerFrame:Lock()
end
function at.Unlock(av)
at.Locked=false
au=true
return at.ColorpickerFrame:Unlock()
end

if at.Locked then
at:Lock()
end


function at.Update(av,aw,ax)
at.UIElements.Colorpicker.ImageTransparency=ax or 0
at.UIElements.Colorpicker.ImageColor3=aw
at.Default=aw
if ax then
at.Transparency=ax
end
end

function at.Set(av,aw,ax)
return at:Update(aw,ax)
end

ac.AddSignal(at.UIElements.Colorpicker.MouseButton1Click,function()
if au then
aq:Colorpicker(at,as.Window,function(av,aw)
at:Update(av,aw)
at.Default=av
at.Transparency=aw
ac.SafeCallback(at.Callback,av,aw)
end).ColorpickerFrame:Open()
end
end)

return at.__type,at
end

return aq end function a.N()
local ac=a.load'a'
local ae=ac.New
local ag=ac.Tween

local ai={}

function ai.New(aj,ak)
local al={
__type="Section",
Title=ak.Title or"Section",
Icon=ak.Icon,
TextXAlignment=ak.TextXAlignment or"Left",
TextSize=ak.TextSize or 19,
Box=ak.Box or false,
FontWeight=ak.FontWeight or Enum.FontWeight.SemiBold,
TextTransparency=ak.TextTransparency or 0.05,
Opened=ak.Opened or false,
UIElements={},

HeaderSize=42,
IconSize=20,
Padding=10,

Elements={},

Expandable=false,
}

local am


function al.SetIcon(an,ao)
al.Icon=ao or nil
if am then am:Destroy()end
if ao then
am=ac.Image(
ao,
ao..":"..al.Title,
0,
ak.Window.Folder,
al.__type,
true
)
am.Size=UDim2.new(0,al.IconSize,0,al.IconSize)
end
end

local an=ae("Frame",{
Size=UDim2.new(0,al.IconSize,0,al.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ae("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ac.Icon"chevron-down"[1],
ImageRectSize=ac.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ac.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})


if al.Icon then
al:SetIcon(al.Icon)
end

local ao=ae("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=al.TextXAlignment,
AutomaticSize="Y",
TextSize=al.TextSize,
TextTransparency=al.TextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ac.Font,al.FontWeight),


Text=al.Title,
Size=UDim2.new(
1,
0,
0,
0
),
TextWrapped=true,
})


local function UpdateTitleSize()
local ap=0
if am then
ap=ap-(al.IconSize+8)
end
if an.Visible then
ap=ap-(al.IconSize+8)
end
ao.Size=UDim2.new(1,ap,0,0)
end


local ap=ac.NewRoundFrame(ak.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=ak.Parent,
ClipsDescendants=true,
AutomaticSize="Y",
ImageTransparency=al.Box and.93 or 1,
ThemeTag={
ImageColor3="Text",
},
},{
ae("TextButton",{
Size=UDim2.new(1,0,0,Expandable and 0 or al.HeaderSize),
BackgroundTransparency=1,
AutomaticSize=Expandable and nil or"Y",
Text="",
Name="Top",
},{
al.Box and ae("UIPadding",{
PaddingLeft=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,ak.Window.ElementConfig.UIPadding),
})or nil,
am,
ao,
ae("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
an,
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=false,
Position=UDim2.new(0,0,0,al.HeaderSize)
},{
al.Box and ae("UIPadding",{
PaddingLeft=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingBottom=UDim.new(0,ak.Window.ElementConfig.UIPadding),
})or nil,
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ak.Tab.Gap),
VerticalAlignment="Top",
}),
})
})







local aq=ak.ElementsModule

aq.Load(al,ap.Content,aq.Elements,ak.Window,ak.WindUI,function()
if not al.Expandable then
al.Expandable=true
an.Visible=true
UpdateTitleSize()
end
end,aq,ak.UIScale,ak.Tab)


UpdateTitleSize()

function al.SetTitle(ar,as)
ao.Text=as
end

function al.Destroy(ar)
for as,at in next,al.Elements do
at:Destroy()
end








ap:Destroy()
end

function al.Open(ar)
if al.Expandable then
al.Opened=true
ag(ap,0.33,{
Size=UDim2.new(1,0,0,al.HeaderSize+(ap.Content.AbsoluteSize.Y/ak.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ag(an.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function al.Close(ar)
if al.Expandable then
al.Opened=false
ag(ap,0.26,{
Size=UDim2.new(1,0,0,al.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ag(an.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ac.AddSignal(ap.Top.MouseButton1Click,function()
if al.Expandable then
if al.Opened then
al:Close()
else
al:Open()
end
end
end)

task.spawn(function()
task.wait()
if al.Expandable then








ap.Size=UDim2.new(1,0,0,al.HeaderSize)
ap.AutomaticSize="None"
ap.Top.Size=UDim2.new(1,0,0,al.HeaderSize)
ap.Top.AutomaticSize="None"
ap.Content.Visible=true
end
if al.Opened then
al:Open()
end

end)

return al.__type,al
end

return ai end function a.O()
local ac=a.load'a'
local ae=ac.New

local ag={}

function ag.New(ai,aj)
local ak=ae("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local al=ae("Frame",{
Parent=aj.Parent,
Size=UDim2.new(1,-7,0,7),
BackgroundTransparency=1,
},{
ak
})

return"Divider",{__type="Divider",ElementFrame=al}
end

return ag end function a.P()
local ac=a.load'a'
local ae=ac.New

local ag={}

function ag.New(ai,aj)
local ak=ae("Frame",{
Parent=aj.Parent,
Size=UDim2.new(1,-7,0,7*(aj.Columns or 1)),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=ak}
end

return ag end function a.Q()
local ac=a.load'a'
local ae=ac.New

local ag={}

local function ParseAspectRatio(ai)
if type(ai)=="string"then
local aj,ak=ai:match"(%d+):(%d+)"
if aj and ak then
return tonumber(aj)/tonumber(ak)
end
elseif type(ai)=="number"then
return ai
end
return nil
end

function ag.New(ai,aj)
local ak={
__type="Image",
Image=aj.Image or"",
AspectRatio=aj.AspectRatio or"16:9",
Radius=aj.Radius or aj.Window.ElementConfig.UICorner,
}
local al=ac.Image(
ak.Image,
ak.Image,
ak.Radius,
aj.Window.Folder,
"Image",
false
)
al.Parent=aj.Parent
al.Size=UDim2.new(1,0,0,0)
al.BackgroundTransparency=1












local am=ParseAspectRatio(aj.AspectRatio)
local an

if am then
an=ae("UIAspectRatioConstraint",{
Parent=al,
AspectRatio=am,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function ak.Destroy(ao)
al:Destroy()
end

return ak.__type,ak
end

return ag end function a.R()
return{
Elements={
Paragraph=a.load'z',
Button=a.load'A',
Toggle=a.load'D',
Slider=a.load'E',
Keybind=a.load'F',
Input=a.load'G',
Dropdown=a.load'I',
Code=a.load'L',
Colorpicker=a.load'M',
Section=a.load'N',
Divider=a.load'O',
Space=a.load'P',
Image=a.load'Q',
},
Load=function(ac,ae,ag,ai,aj,ak,al,am,an)
for ao,ap in next,ag do
ac[ao]=function(aq,ar)
ar=ar or{}
ar.Tab=an or ac
ar.ParentTable=ac
ar.Index=#ac.Elements+1
ar.GlobalIndex=#ai.AllElements+1
ar.Parent=ae
ar.Window=ai
ar.WindUI=aj
ar.UIScale=am
ar.ElementsModule=al local

as, at=ap:New(ar)


local au
for av,aw in pairs(at)do
if typeof(aw)=="table"and av:match"Frame$"then
au=aw
break
end
end

if au then
at.ElementFrame=au.UIElements.Main
function at.SetTitle(av,aw)
au:SetTitle(aw)
end
function at.SetDesc(av,aw)
au:SetDesc(aw)
end
function at.Highlight(av)
au:Highlight()
end
function at.Destroy(av)

table.remove(ai.AllElements,ar.GlobalIndex)
table.remove(ac.Elements,ar.Index)
table.remove(an.Elements,ar.Index)
ac:UpdateAllElementShapes(ac)

au:Destroy()
end
end



ai.AllElements[ar.Index]=at
ac.Elements[ar.Index]=at
if an then an.Elements[ar.Index]=at end

if ai.NewElements then
ac:UpdateAllElementShapes(ac)
end

if ak then
ak()
end
return at
end
end
function ac.UpdateAllElementShapes(ao,ap)
for aq,ar in next,ap.Elements do
local as
for at,au in pairs(ar)do
if typeof(au)=="table"and at:match"Frame$"then
as=au
break
end
end

if as then

as.Index=aq
if as.UpdateShape then

as.UpdateShape(ap)
end
end
end
end
end,

}end function a.S()
game:GetService"UserInputService"
local ac=game.Players.LocalPlayer:GetMouse()

local ae=a.load'a'
local ag=ae.New
local ai=ae.Tween

local aj=a.load'x'.New
local ak=a.load't'.New





local al={


Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(al)end
}

function al.Init(am,an,ao,ap)
Window=am
WindUI=an
al.ToolTipParent=ao
al.TabHighlight=ap
return al
end

function al.New(am,an)
local ao={
__type="Tab",
Title=am.Title or"Tab",
Desc=am.Desc,
Icon=am.Icon,
IconThemed=am.IconThemed,
Locked=am.Locked,
ShowTabTitle=am.ShowTabTitle,
Selected=false,
Index=nil,
Parent=am.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=Window.UICorner-(Window.UIPadding/2),

Gap=Window.NewElements and 1 or 6,
}

al.TabCount=al.TabCount+1

local ap=al.TabCount
ao.Index=ap

ao.UIElements.Main=ae.NewRoundFrame(ao.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=am.Parent,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
},{
ae.NewRoundFrame(ao.UICorner,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
ag("UIGradient",{
Rotation=80,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
ae.NewRoundFrame(ao.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
},{
ag("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ag("TextLabel",{
Text=ao.Title,
ThemeTag={
TextColor3="Text"
},
TextTransparency=not ao.Locked and 0.4 or.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,2+(Window.UIPadding/2)),
PaddingLeft=UDim.new(0,4+(Window.UIPadding/2)),
PaddingRight=UDim.new(0,4+(Window.UIPadding/2)),
PaddingBottom=UDim.new(0,2+(Window.UIPadding/2)),
})
}),
},true)

local aq=0
local ar
local as

if ao.Icon then
ar=ae.Image(
ao.Icon,
ao.Icon..":"..ao.Title,
0,
Window.Folder,
ao.__type,
true,
ao.IconThemed
)
ar.Size=UDim2.new(0,16,0,16)
ar.Parent=ao.UIElements.Main.Frame
ar.ImageLabel.ImageTransparency=not ao.Locked and 0 or.7
ao.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,-30,0,0)
aq=-30

ao.UIElements.Icon=ar


as=ae.Image(
ao.Icon,
ao.Icon..":"..ao.Title,
0,
Window.Folder,
ao.__type,
true,
ao.IconThemed
)
as.Size=UDim2.new(0,16,0,16)
as.ImageLabel.ImageTransparency=not ao.Locked and 0 or.7
aq=-30




end

ao.UIElements.ContainerFrame=ag("ScrollingFrame",{
Size=UDim2.new(1,0,1,ao.ShowTabTitle and-((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),
AutomaticCanvasSize="Y",

ScrollingDirection="Y",
},{
ag("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
ag("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,ao.Gap),
HorizontalAlignment="Center",
})
})





ao.UIElements.ContainerFrameCanvas=ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
},{
ao.UIElements.ContainerFrame,
ag("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=ao.ShowTabTitle or false,
Name="TabTitle"
},{
as,
ag("TextLabel",{
Text=ao.Title,
ThemeTag={
TextColor3="Text"
},
TextSize=20,
TextTransparency=.1,
Size=UDim2.new(1,-aq,1,0),
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
TextTruncate="AtEnd",
RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
ag("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
ag("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=ao.ShowTabTitle or false,
})
})

al.Containers[ap]=ao.UIElements.ContainerFrameCanvas
al.Tabs[ap]=ao

ao.ContainerFrame=ContainerFrameCanvas

ae.AddSignal(ao.UIElements.Main.MouseButton1Click,function()
if not ao.Locked then
al:SelectTab(ap)
end
end)

if Window.ScrollBarEnabled then
ak(ao.UIElements.ContainerFrame,ao.UIElements.ContainerFrameCanvas,Window,3)
end

local at
local au
local av
local aw=false



if ao.Desc then


ae.AddSignal(ao.UIElements.Main.InputBegan,function()
aw=true
au=task.spawn(function()
task.wait(0.35)
if aw and not at then
at=aj(ao.Desc,al.ToolTipParent)

local function updatePosition()
if at then
at.Container.Position=UDim2.new(0,ac.X,0,ac.Y-20)
end
end

updatePosition()
av=ac.Move:Connect(updatePosition)
at:Open()
end
end)
end)

end

ae.AddSignal(ao.UIElements.Main.MouseEnter,function()
if not ao.Locked then
ai(ao.UIElements.Main.Frame,0.08,{ImageTransparency=.97}):Play()
end
end)
ae.AddSignal(ao.UIElements.Main.InputEnded,function()
if ao.Desc then
aw=false
if au then
task.cancel(au)
au=nil
end
if av then
av:Disconnect()
av=nil
end
if at then
at:Close()
at=nil
end
end

if not ao.Locked then
ai(ao.UIElements.Main.Frame,0.08,{ImageTransparency=1}):Play()
end
end)



function ao.ScrollToTheElement(ax,ay)
ao.UIElements.ContainerFrame.ScrollingEnabled=false
ai(ao.UIElements.ContainerFrame,.45,
{
CanvasPosition=Vector2.new(
0,

ao.Elements[ay].ElementFrame.AbsolutePosition.Y
-ao.UIElements.ContainerFrame.AbsolutePosition.Y
-ao.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
)
},
Enum.EasingStyle.Quint,Enum.EasingDirection.Out
):Play()

task.spawn(function()
task.wait(.48)

if ao.Elements[ay].Highlight then
ao.Elements[ay]:Highlight()
ao.UIElements.ContainerFrame.ScrollingEnabled=true
end
end)

return ao
end





ao.ElementsModule=a.load'R'

ao.ElementsModule.Load(ao,ao.UIElements.ContainerFrame,ao.ElementsModule.Elements,Window,WindUI,nil,ao.ElementsModule,an)



function ao.LockAll(ax)

for ay,az in next,Window.AllElements do
if az.Tab and az.Tab.Index and az.Tab.Index==ao.Index and az.Lock then
az:Lock()
end
end
end
function ao.UnlockAll(ax)
for ay,az in next,Window.AllElements do
if az.Tab and az.Tab.Index and az.Tab.Index==ao.Index and az.Unlock then
az:Unlock()
end
end
end
function ao.GetLocked(ax)
local ay={}

for az,aA in next,Window.AllElements do
if aA.Tab and aA.Tab.Index and aA.Tab.Index==ao.Index and aA.Locked==true then
table.insert(ay,aA)
end
end

return ay
end
function ao.GetUnlocked(ax)
local ay={}

for az,aA in next,Window.AllElements do
if aA.Tab and aA.Tab.Index and aA.Tab.Index==ao.Index and aA.Locked==false then
table.insert(ay,aA)
end
end

return ay
end

function ao.Select(ax)
return al:SelectTab(ao.Index)
end

task.spawn(function()
local ax=ag("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=ao.UIElements.ContainerFrame
},{
ag("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),
ag("ImageLabel",{
Size=UDim2.new(0,48,0,48),
Image=ae.Icon"frown"[1],
ImageRectOffset=ae.Icon"frown"[2].ImageRectPosition,
ImageRectSize=ae.Icon"frown"[2].ImageRectSize,
ThemeTag={
ImageColor3="Icon"
},
BackgroundTransparency=1,
ImageTransparency=.6,
}),
ag("TextLabel",{
AutomaticSize="XY",
Text="This tab is empty",
ThemeTag={
TextColor3="Text"
},
TextSize=18,
TextTransparency=.5,
BackgroundTransparency=1,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
})
})





local ay
ay=ae.AddSignal(ao.UIElements.ContainerFrame.ChildAdded,function()
ax.Visible=false
ay:Disconnect()
end)
end)

return ao
end

function al.OnChange(am,an)
al.OnChangeFunc=an
end

function al.SelectTab(am,an)
if not al.Tabs[an].Locked then
al.SelectedTab=an

for ao,ap in next,al.Tabs do
if not ap.Locked then
ai(ap.UIElements.Main,0.15,{ImageTransparency=1}):Play()
ai(ap.UIElements.Main.Outline,0.15,{ImageTransparency=1}):Play()
ai(ap.UIElements.Main.Frame.TextLabel,0.15,{TextTransparency=0.3}):Play()
if ap.UIElements.Icon then
ai(ap.UIElements.Icon.ImageLabel,0.15,{ImageTransparency=0.4}):Play()
end
ap.Selected=false
end
end
ai(al.Tabs[an].UIElements.Main,0.15,{ImageTransparency=0.95}):Play()
ai(al.Tabs[an].UIElements.Main.Outline,0.15,{ImageTransparency=0.85}):Play()
ai(al.Tabs[an].UIElements.Main.Frame.TextLabel,0.15,{TextTransparency=0}):Play()
if al.Tabs[an].UIElements.Icon then
ai(al.Tabs[an].UIElements.Icon.ImageLabel,0.15,{ImageTransparency=0.1}):Play()
end
al.Tabs[an].Selected=true


task.spawn(function()
for ao,ap in next,al.Containers do
ap.AnchorPoint=Vector2.new(0,0.05)
ap.Visible=false
end
al.Containers[an].Visible=true
ai(al.Containers[an],0.15,{AnchorPoint=Vector2.new(0,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()
end)

al.OnChangeFunc(an)
end
end

return al end function a.T()
local ac={}


local ae=a.load'a'
local ag=ae.New
local ai=ae.Tween

local aj=a.load'S'

function ac.New(ak,al,am,an,ao)
local ap={
Title=ak.Title or"Section",
Icon=ak.Icon,
IconThemed=ak.IconThemed,
Opened=ak.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local aq
if ap.Icon then
aq=ae.Image(
ap.Icon,
ap.Icon,
0,
am,
"Section",
true,
ap.IconThemed
)

aq.Size=UDim2.new(0,ap.IconSize,0,ap.IconSize)
aq.ImageLabel.ImageTransparency=.25
end

local ar=ag("Frame",{
Size=UDim2.new(0,ap.IconSize,0,ap.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ag("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ae.Icon"chevron-down"[1],
ImageRectSize=ae.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ae.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local as=ag("Frame",{
Size=UDim2.new(1,0,0,ap.HeaderSize),
BackgroundTransparency=1,
Parent=al,
ClipsDescendants=true,
},{
ag("TextButton",{
Size=UDim2.new(1,0,0,ap.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
aq,
ag("TextLabel",{
Text=ap.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
aq and(-ap.IconSize-10)*2
or(-ap.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
ag("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
ar,
ag("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
ag("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,ap.HeaderSize)
},{
ag("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ao.Gap),
VerticalAlignment="Bottom",
}),
})
})


function ap.Tab(at,au)
if not ap.Expandable then
ap.Expandable=true
ar.Visible=true
end
au.Parent=as.Content
return aj.New(au,an)
end

function ap.Open(at)
if ap.Expandable then
ap.Opened=true
ai(as,0.33,{
Size=UDim2.new(1,0,0,ap.HeaderSize+(as.Content.AbsoluteSize.Y/an))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ai(ar.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ap.Close(at)
if ap.Expandable then
ap.Opened=false
ai(as,0.26,{
Size=UDim2.new(1,0,0,ap.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ai(ar.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ae.AddSignal(as.TextButton.MouseButton1Click,function()
if ap.Expandable then
if ap.Opened then
ap:Close()
else
ap:Open()
end
end
end)

if ap.Opened then
task.spawn(function()
task.wait()
ap:Open()
end)
end



return ap
end


return ac end function a.U()
return{
Tab="table-of-contents",
Paragraph="type",
Button="square-mouse-pointer",
Toggle="toggle-right",
Slider="sliders-horizontal",
Keybind="command",
Input="text-cursor-input",
Dropdown="chevrons-up-down",
Code="terminal",
Colorpicker="palette",
}end function a.V()
game:GetService"UserInputService"

local ac={
Margin=8,
Padding=9,
}


local ae=a.load'a'
local ag=ae.New
local ai=ae.Tween


function ac.new(aj,ak,al)
local am={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.load'U'
}


local an=ag("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(
1,
-((am.IconSize*2)+(am.Padding*2)),
0,
0
),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Regular),
TextSize=18,
})

local ao=ag("ImageLabel",{
Image=ae.Icon"x"[1],
ImageRectSize=ae.Icon"x"[2].ImageRectSize,
ImageRectOffset=ae.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize)
},{
ag("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})

local ap=ag("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding),
})
})

local aq=ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=0,
},{
ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.98,
Name="Frame",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ag("ImageLabel",{
Image=ae.Icon"search"[1],
ImageRectSize=ae.Icon"search"[2].ImageRectSize,
ImageRectOffset=ae.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize)
}),
an,
ao,
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ag("UIPadding",{
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
})
})
}),
ag("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=.9,
Visible=false,
}),
ap,
ag("UISizeConstraint",{
MaxSize=Vector2.new(am.Width,am.MaxHeight),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
})
})

local ar=ag("Frame",{
Size=UDim2.new(0,am.Width,0,0),
AutomaticSize="Y",
Parent=ak,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
ag("UIScale",{
Scale=.9,
}),
aq,
ae.NewRoundFrame(am.Radius,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=1,
},{
ag("UIGradient",{
Rotation=45,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.55),
NumberSequenceKeypoint.new(0.5,0.8),
NumberSequenceKeypoint.new(1,0.6)
}
})
})
})

local function CreateSearchTab(as,at,au,av,aw,ax)
local ay=ag("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=av or nil
},{
ae.NewRoundFrame(am.Radius-11,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main"
},{
ae.NewRoundFrame(am.Radius-11,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=1,
Name="Outline",
},{
ag("UIGradient",{
Rotation=65,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.55),
NumberSequenceKeypoint.new(0.5,0.8),
NumberSequenceKeypoint.new(1,0.6)
}
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding-2),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding-2),
}),
ag("ImageLabel",{
Image=ae.Icon(au)[1],
ImageRectSize=ae.Icon(au)[2].ImageRectSize,
ImageRectOffset=ae.Icon(au)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize)
}),
ag("Frame",{
Size=UDim2.new(1,-am.IconSize-am.Padding,0,0),
BackgroundTransparency=1,
},{
ag("TextLabel",{
Text=as,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title"
}),
ag("TextLabel",{
Text=at or"",
Visible=at and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc"
})or nil,
ag("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
})
}),
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
})
}),
},true),
ag("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-am.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=aw,

},{
ae.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=.9,
}),
ag("Frame",{
Size=UDim2.new(1,-am.Padding-2,0,0),
Position=UDim2.new(0,am.Padding+2,0,0),
BackgroundTransparency=1,
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right"
})
})



ay.Main.Size=UDim2.new(
1,
0,
0,
ay.Main.Outline.Frame.Desc.Visible and(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y+6+ay.Main.Outline.Frame.Desc.TextBounds.Y)
or(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y)
)

ae.AddSignal(ay.Main.MouseEnter,function()
ai(ay.Main,.04,{ImageTransparency=.95}):Play()
ai(ay.Main.Outline,.04,{ImageTransparency=.7}):Play()
end)
ae.AddSignal(ay.Main.InputEnded,function()
ai(ay.Main,.08,{ImageTransparency=1}):Play()
ai(ay.Main.Outline,.08,{ImageTransparency=1}):Play()
end)
ae.AddSignal(ay.Main.MouseButton1Click,function()
if ax then
ax()
end
end)

return ay
end

local function ContainsText(as,at)
if not at or at==""then
return false
end

if not as or as==""then
return false
end

local au=string.lower(as)
local av=string.lower(at)

return string.find(au,av,1,true)~=nil
end

local function Search(as)
if not as or as==""then
return{}
end

local at={}
for au,av in next,aj.Tabs do
local aw=ContainsText(av.Title or"",as)
local ax={}

for ay,az in next,av.Elements do
if az.__type~="Section"then
local aA=ContainsText(az.Title or"",as)
local b=ContainsText(az.Desc or"",as)

if aA or b then
ax[ay]={
Title=az.Title,
Desc=az.Desc,
Original=az,
__type=az.__type,
Index=ay,
}
end
end
end

if aw or next(ax)~=nil then
at[au]={
Tab=av,
Title=av.Title,
Icon=av.Icon,
Elements=ax,
}
end
end
return at
end

function am.Search(as,at)
at=at or""

local au=Search(at)

ap.Visible=true
aq.Frame.Results.Frame.Visible=true
for av,aw in next,ap:GetChildren()do
if aw.ClassName~="UIListLayout"and aw.ClassName~="UIPadding"then
aw:Destroy()
end
end

if au and next(au)~=nil then
for av,aw in next,au do
local ax=am.Icons.Tab
local ay=CreateSearchTab(aw.Title,nil,ax,ap,true,function()
am:Close()
aj:SelectTab(av)
end)
if aw.Elements and next(aw.Elements)~=nil then
for az,aA in next,aw.Elements do
local b=am.Icons[aA.__type]
CreateSearchTab(aA.Title,aA.Desc,b,ay:FindFirstChild"ParentContainer"and ay.ParentContainer.Frame or nil,false,function()
am:Close()
aj:SelectTab(av)
if aw.Tab.ScrollToTheElement then

aw.Tab:ScrollToTheElement(aA.Index)
end

end)

end
end
end
elseif at~=""then
ag("TextLabel",{
Size=UDim2.new(1,0,0,70),
BackgroundTransparency=1,
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=.2,
BackgroundTransparency=1,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Parent=ap,
Name="NotFound",
})
else
ap.Visible=false
aq.Frame.Results.Frame.Visible=false
end
end

ae.AddSignal(an:GetPropertyChangedSignal"Text",function()
am:Search(an.Text)
end)

ae.AddSignal(ap.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

ai(ap,.06,{Size=UDim2.new(
1,
0,
0,
math.clamp(ap.UIListLayout.AbsoluteContentSize.Y+(am.Padding*2),0,am.MaxHeight)
)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function am.Open(as)
task.spawn(function()
aq.Frame.Visible=true
ar.Visible=true
ai(ar.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function am.Close(as)
task.spawn(function()
al()
aq.Frame.Visible=false
ai(ar.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.12)
ar.Visible=false
end)
end

ae.AddSignal(ao.TextButton.MouseButton1Click,function()
am:Close()
end)

am:Open()

return am
end

return ac end function a.W()

local ac=game:GetService"UserInputService"
game:GetService"RunService"

local ae=workspace.CurrentCamera



local ag=a.load'a'
local ai=ag.New
local aj=ag.Tween


local ak=a.load's'.New
local al=a.load'i'.New
local am=a.load't'.New
local an=a.load'u'

local ao=a.load'v'



return function(ap)
local aq={
Title=ap.Title or"UI Library",
Author=ap.Author,
Icon=ap.Icon,
IconThemed=ap.IconThemed,
Folder=ap.Folder,
Resizable=ap.Resizable,
Background=ap.Background,
BackgroundImageTransparency=ap.BackgroundImageTransparency or 0,
User=ap.User or{},

Size=ap.Size,

MinSize=ap.MinSize or Vector2.new(560,350),
MaxSize=ap.MaxSize or Vector2.new(850,560),

ToggleKey=ap.ToggleKey,
Transparent=ap.Transparent or false,
HideSearchBar=ap.HideSearchBar,
ScrollBarEnabled=ap.ScrollBarEnabled or false,
SideBarWidth=ap.SideBarWidth or 200,

NewElements=ap.NewElements or false,
HidePanelBackground=ap.HidePanelBackground or false,
AutoScale=ap.AutoScale,
OpenButton=ap.OpenButton,

Position=UDim2.new(0.5,0,0.5,0),
IconSize=ap.IconSize or 22,
UICorner=16,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=ap.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=false,
IsOpenButtonEnabled=true,

ConfigManager=nil,

CurrentTab=nil,
TabModule=nil,

OnOpenCallback=nil,
OnCloseCallback=nil,
OnDestroyCallback=nil,

IsPC=false,

Gap=5,

TopBarButtons={},
AllElements={},

ElementConfig={}
}


aq.ElementConfig={
UIPadding=aq.NewElements and 10 or 13,
UICorner=aq.NewElements and 23 or 12,
}

local ar=aq.Size or UDim2.new(0,580,0,460)
aq.Size=UDim2.new(
ar.X.Scale,
math.clamp(ar.X.Offset,aq.MinSize.X,aq.MaxSize.X),
ar.Y.Scale,
math.clamp(ar.Y.Offset,aq.MinSize.Y,aq.MaxSize.Y)
)

if aq.HideSearchBar~=false then
aq.HideSearchBar=true
end
if aq.AutoScale~=false then
aq.AutoScale=true
end
if aq.Resizable~=false then
aq.CanResize=true
aq.Resizable=true
end

if aq.Folder then
makefolder("WindUI/"..aq.Folder)
end

local as=ai("UICorner",{
CornerRadius=UDim.new(0,aq.UICorner)
})

if aq.Folder then
aq.ConfigManager=ao:Init(aq)
end







local at=ai("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(.5,.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true
},{
ai("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
})
})
local au=ag.NewRoundFrame(aq.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
ai("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=ag.Icon"expand"[1],
ImageRectOffset=ag.Icon"expand"[2].ImageRectPosition,
ImageRectSize=ag.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local av=ag.NewRoundFrame(aq.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})










aq.UIElements.SideBar=ai("ScrollingFrame",{
Size=UDim2.new(
1,
aq.ScrollBarEnabled and-3-(aq.UIPadding/2)or 0,
1,
not aq.HideSearchBar and-45 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ClipsDescendants=true,
VerticalScrollBarPosition="Left",
},{
ai("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,aq.UIPadding/2),


PaddingBottom=UDim.new(0,aq.UIPadding/2),
}),
ai("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,aq.Gap)
})
}),
ai("UIPadding",{

PaddingLeft=UDim.new(0,aq.UIPadding/2),
PaddingRight=UDim.new(0,aq.UIPadding/2),

}),

})

aq.UIElements.SideBarContainer=ai("Frame",{
Size=UDim2.new(0,aq.SideBarWidth,1,aq.User.Enabled and-94-(aq.UIPadding*2)or-52),
Position=UDim2.new(0,0,0,52),
BackgroundTransparency=1,
Visible=true,
},{
ai("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(
1,
0,
1,
not aq.HideSearchBar and-45-aq.UIPadding/2 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
}),
aq.UIElements.SideBar,
})

if aq.ScrollBarEnabled then
am(aq.UIElements.SideBar,aq.UIElements.SideBarContainer.Content,aq,3)
end


aq.UIElements.MainBar=ai("Frame",{
Size=UDim2.new(1,-aq.UIElements.SideBarContainer.AbsoluteSize.X,1,-52),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
ag.NewRoundFrame(aq.UICorner-(aq.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ZIndex=3,
ImageTransparency=.95,
Name="Background",
Visible=not aq.HidePanelBackground
}),
ai("UIPadding",{
PaddingTop=UDim.new(0,aq.UIPadding/2),
PaddingLeft=UDim.new(0,aq.UIPadding/2),
PaddingRight=UDim.new(0,aq.UIPadding/2),
PaddingBottom=UDim.new(0,aq.UIPadding/2),
})
})

local aw=ai("ImageLabel",{
Image="rbxassetid://8992230677",
ImageColor3=Color3.new(0,0,0),
ImageTransparency=1,
Size=UDim2.new(1,120,1,116),
Position=UDim2.new(0,-60,0,-58),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})


if ac.TouchEnabled and not ac.KeyboardEnabled then
aq.IsPC=false
elseif ac.KeyboardEnabled then
aq.IsPC=true
else
aq.IsPC=nil
end










local ax
if aq.User then
local function GetUserThumb()local
ay=game:GetService"Players":GetUserThumbnailAsync(
aq.User.Anonymous and 1 or game.Players.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return ay
end


ax=ai("TextButton",{
Size=UDim2.new(0,
(aq.UIElements.SideBarContainer.AbsoluteSize.X)-(aq.UIPadding/2),
0,
42+(aq.UIPadding)
),
Position=UDim2.new(0,aq.UIPadding/2,1,-(aq.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=aq.User.Enabled or false,
},{
ag.NewRoundFrame(aq.UICorner-(aq.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
ai("UIGradient",{
Rotation=78,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
ag.NewRoundFrame(aq.UICorner-(aq.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
ai("ImageLabel",{
Image=GetUserThumb(),
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=.93,
},{
ai("UICorner",{
CornerRadius=UDim.new(1,0)
})
}),
ai("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
ai("TextLabel",{
Text=aq.User.Anonymous and"Anonymous"or game.Players.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ag.Font,Enum.FontWeight.SemiBold),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="DisplayName"
}),
ai("TextLabel",{
Text=aq.User.Anonymous and"anonymous"or game.Players.LocalPlayer.Name,
TextSize=15,
TextTransparency=.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ag.Font,Enum.FontWeight.Medium),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="UserName"
}),
ai("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
})
}),
ai("UIListLayout",{
Padding=UDim.new(0,aq.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai("UIPadding",{
PaddingLeft=UDim.new(0,aq.UIPadding/2),
PaddingRight=UDim.new(0,aq.UIPadding/2),
})
})
})


function aq.User.Enable(ay)
aq.User.Enabled=true
aj(aq.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,aq.SideBarWidth,1,-94-(aq.UIPadding*2))},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ax.Visible=true
end
function aq.User.Disable(ay)
aq.User.Enabled=false
aj(aq.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,aq.SideBarWidth,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ax.Visible=false
end
function aq.User.SetAnonymous(ay,az)
if az~=false then az=true end
aq.User.Anonymous=az
ax.UserIcon.ImageLabel.Image=GetUserThumb()
ax.UserIcon.Frame.DisplayName.Text=az and"Anonymous"or game.Players.LocalPlayer.DisplayName
ax.UserIcon.Frame.UserName.Text=az and"anonymous"or game.Players.LocalPlayer.Name
end

if aq.User.Enabled then
aq.User:Enable()
else
aq.User:Disable()
end

if aq.User.Callback then
ag.AddSignal(ax.MouseButton1Click,function()
aq.User.Callback()
end)
ag.AddSignal(ax.MouseEnter,function()
aj(ax.UserIcon,0.04,{ImageTransparency=.95}):Play()
aj(ax.Outline,0.04,{ImageTransparency=.85}):Play()
end)
ag.AddSignal(ax.InputEnded,function()
aj(ax.UserIcon,0.04,{ImageTransparency=1}):Play()
aj(ax.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local ay
local az


local aA=false
local b

local e=typeof(aq.Background)=="string"and string.match(aq.Background,"^video:(.+)")or nil
local g=typeof(aq.Background)=="string"and not e and string.match(aq.Background,"^https?://.+")or nil

local function SanitizeFilename(h)
h=h:gsub("[%s/\\:*?\"<>|]+","-")
h=h:gsub("[^%w%-_%.]","")
return h
end

if typeof(aq.Background)=="string"and e then
aA=true

if string.find(e,"http")then
local h=aq.Folder.."/Assets/."..SanitizeFilename(e)..".webm"
if not isfile(h)then
local i,j=pcall(function()
local i=ag.Request{Url=e,Method="GET"}
writefile(h,i.Body)
end)
if not i then
warn("[ Window.Background ] Failed to download video: "..tostring(j))
return
end
end

local i,j=pcall(function()
return getcustomasset(h)
end)
if not i then
warn("[ Window.Background ] Failed to load custom asset: "..tostring(j))
return
end
e=j
end

b=ai("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=e,
Looped=true,
Volume=0,
},{
ai("UICorner",{
CornerRadius=UDim.new(0,aq.UICorner)
}),
})
b:Play()

elseif g then
local h=aq.Folder.."/Assets/."..SanitizeFilename(g)..".png"
if not isfile(h)then
local i,j=pcall(function()
local i=ag.Request{Url=g,Method="GET"}
writefile(h,i.Body)
end)
if not i then
warn("[ Window.Background ] Failed to download image: "..tostring(j))
return
end
end

local i,j=pcall(function()
return getcustomasset(h)
end)
if not i then
warn("[ Window.Background ] Failed to load custom asset: "..tostring(j))
return
end

b=ai("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=j,
ImageTransparency=0,
ScaleType="Crop",
},{
ai("UICorner",{
CornerRadius=UDim.new(0,aq.UICorner)
}),
})

elseif aq.Background then
b=ai("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=typeof(aq.Background)=="string"and aq.Background or"",
ImageTransparency=1,
ScaleType="Crop",
},{
ai("UICorner",{
CornerRadius=UDim.new(0,aq.UICorner)
}),
})
end


local h=ag.NewRoundFrame(99,"Squircle",{
ImageTransparency=.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
},{
ai("TextButton",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
ZIndex=99,
Name="Frame",
})
})

function createAuthor(i)
return ai("TextLabel",{
Text=i,
FontFace=Font.new(ag.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=aq.UIElements.Main and aq.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="Text"
},
Name="Author",
})
end

local i
local j

if aq.Author then
i=createAuthor(aq.Author)
end


local l=ai("TextLabel",{
Text=aq.Title,
FontFace=Font.new(ag.Font,Enum.FontWeight.SemiBold),
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=16,
ThemeTag={
TextColor3="Text"
}
})

aq.UIElements.Main=ai("Frame",{
Size=aq.Size,
Position=aq.Position,
BackgroundTransparency=1,
Parent=ap.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
},{

aw,
ag.NewRoundFrame(aq.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,-240),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="Background"
},

},{
b,
h,
at,



}),
UIStroke,
as,
au,
av,
ai("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
ai("UICorner",{
CornerRadius=UDim.new(0,aq.UICorner)
}),
aq.UIElements.SideBarContainer,
aq.UIElements.MainBar,

ax,

az,
ai("Frame",{
Size=UDim2.new(1,0,0,52),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar"
},{
ay,






ai("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left"
},{
ai("UIListLayout",{
Padding=UDim.new(0,aq.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
ai("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
l,
i,
}),
ai("UIPadding",{
PaddingLeft=UDim.new(0,4)
})
}),
ai("ScrollingFrame",{
Name="Center",
BackgroundTransparency=1,
AutomaticSize="Y",
ScrollBarThickness=0,
ScrollingDirection="X",
AutomaticCanvasSize="X",
CanvasSize=UDim2.new(0,0,0,0),
Size=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
Visible=false,
},{
ai("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,aq.UIPadding/2)
})
}),
ai("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
Name="Right",
},{
ai("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
}),

}),
ai("UIPadding",{
PaddingTop=UDim.new(0,aq.UIPadding),
PaddingLeft=UDim.new(0,aq.UIPadding),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,aq.UIPadding),
})
})
})
})

ag.AddSignal(aq.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal"AbsoluteSize",function()
local m=0
local p=aq.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X
if l and i then
m=math.max(l.TextBounds.X,i.TextBounds.X)
else
m=l.TextBounds.X
end
if j then
m=m+aq.IconSize+aq.UIPadding+4
end
aq.UIElements.Main.Main.Topbar.Center.Position=UDim2.new(0,m+aq.UIPadding,0.5,0)
aq.UIElements.Main.Main.Topbar.Center.Size=UDim2.new(
1,
-m-p-(aq.UIPadding*2),
1,
0
)
end)

function aq.CreateTopbarButton(m,p,r,u,v,x)
local z=ag.Image(
r,
r,
0,
aq.Folder,
"TopbarIcon",
true,
x
)
z.Size=UDim2.new(0,16,0,16)
z.AnchorPoint=Vector2.new(0.5,0.5)
z.Position=UDim2.new(0.5,0,0.5,0)

local A=ag.NewRoundFrame(9,"Squircle",{
Size=UDim2.new(0,36,0,36),
LayoutOrder=v or 999,
Parent=aq.UIElements.Main.Main.Topbar.Right,

ZIndex=9999,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=1
},{
ag.NewRoundFrame(9,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
ai("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
z
},true)



aq.TopBarButtons[100-v]={
Name=p,
Object=A
}

ag.AddSignal(A.MouseButton1Click,function()
u()
end)
ag.AddSignal(A.MouseEnter,function()
aj(A,.15,{ImageTransparency=.93}):Play()
aj(A.Outline,.15,{ImageTransparency=.75}):Play()

end)
ag.AddSignal(A.MouseLeave,function()
aj(A,.1,{ImageTransparency=1}):Play()
aj(A.Outline,.1,{ImageTransparency=1}):Play()

end)

return A
end



local m=ag.Drag(
aq.UIElements.Main,
{aq.UIElements.Main.Main.Topbar,h.Frame},
function(m,p)
if not aq.Closed then
if m and p==h.Frame then
aj(h,.1,{ImageTransparency=.35}):Play()
else
aj(h,.2,{ImageTransparency=.8}):Play()
end
aq.Position=aq.UIElements.Main.Position
aq.Dragging=m
end
end
)

if not aA and aq.Background and typeof(aq.Background)=="table"then

local p=ai"UIGradient"
for r,u in next,aq.Background do
p[r]=u
end

aq.UIElements.BackgroundGradient=ag.NewRoundFrame(aq.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
Parent=aq.UIElements.Main.Background,
ImageTransparency=aq.Transparent and ap.WindUI.TransparencyValue or 0
},{
p
})
end














aq.OpenButtonMain=a.load'w'.New(aq)


task.spawn(function()
if aq.Icon then

j=ag.Image(
aq.Icon,
aq.Title,
0,
aq.Folder,
"Window",
true,
aq.IconThemed
)
j.Parent=aq.UIElements.Main.Main.Topbar.Left
j.Size=UDim2.new(0,aq.IconSize,0,aq.IconSize)

aq.OpenButtonMain:SetIcon(aq.Icon)











else
aq.OpenButtonMain:SetIcon(aq.Icon)

end
end)

function aq.SetToggleKey(p,r)
aq.ToggleKey=r
end

function aq.SetTitle(p,r)
aq.Title=r
l.Text=r
end

function aq.SetAuthor(p,r)
aq.Author=r
if not i then
i=createAuthor(aq.Author)
end

i.Text=r
end

function aq.SetBackgroundImage(p,r)
aq.UIElements.Main.Background.ImageLabel.Image=r
end
function aq.SetBackgroundImageTransparency(p,r)
if b and b:IsA"ImageLabel"then
b.ImageTransparency=math.floor(r+0.5)
end
aq.BackgroundImageTransparency=math.floor(r+0.5)
end
function aq.SetBackgroundTransparency(p,r)
WindUI.TransparencyValue=math.floor(tonumber(r)+0.5)
aq:ToggleTransparency(math.floor(tonumber(r)+0.5)>0)
end

local p
local r
ag.Icon"minimize"
ag.Icon"maximize"

aq:CreateTopbarButton("Fullscreen","maximize",function()
aq:ToggleFullscreen()
end,998)

function aq.ToggleFullscreen(u)
local v=aq.IsFullscreen

m:Set(v)

if not v then
p=aq.UIElements.Main.Position
r=aq.UIElements.Main.Size

aq.CanResize=false
else
if aq.Resizable then
aq.CanResize=true
end
end

aj(aq.UIElements.Main,0.45,{Size=v and r or UDim2.new(1,-20,1,-72)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

aj(aq.UIElements.Main,0.45,{Position=v and p or UDim2.new(0.5,0,0.5,26)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()



aq.IsFullscreen=not v
end


aq:CreateTopbarButton("Minimize","minus",function()
aq:Close()
task.spawn(function()
task.wait(.3)
if not aq.IsPC and aq.IsOpenButtonEnabled then

aq.OpenButtonMain:Visible(true)
end
end)















end,997)

function aq.OnOpen(u,v)
aq.OnOpenCallback=v
end
function aq.OnClose(u,v)
aq.OnCloseCallback=v
end
function aq.OnDestroy(u,v)
aq.OnDestroyCallback=v
end





function aq.SetIconSize(u,v)
local x
if typeof(v)=="number"then
x=UDim2.new(0,v,0,v)
aq.IconSize=v
elseif typeof(v)=="UDim2"then
x=v
aq.IconSize=v.X.Offset
end

if j then
j.Size=x
end
end

function aq.Open(u)
task.spawn(function()
if aq.OnOpenCallback then
task.spawn(function()
ag.SafeCallback(aq.OnOpenCallback)
end)
end


task.wait(.06)
aq.Closed=false

aj(aq.UIElements.Main.Background,0.2,{
ImageTransparency=aq.Transparent and ap.WindUI.TransparencyValue or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if aq.UIElements.BackgroundGradient then
aj(aq.UIElements.BackgroundGradient,0.2,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

aj(aq.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,0),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()

if b then
if b:IsA"VideoFrame"then
b.Visible=true
else
aj(b,0.2,{
ImageTransparency=aq.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end


aj(aw,0.25,{ImageTransparency=.7},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
aj(UIStroke,0.25,{Transparency=.8},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.spawn(function()
task.wait(.3)
aj(h,.45,{Size=UDim2.new(0,200,0,4),ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
m:Set(true)
task.wait(.45)
if aq.Resizable then
aj(at.ImageLabel,.45,{ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
aq.CanResize=true
end
end)


aq.CanDropdown=true

aq.UIElements.Main.Visible=true
task.spawn(function()
task.wait(.05)
aq.UIElements.Main:WaitForChild"Main".Visible=true


end)
end)
end
function aq.Close(u)
local v={}

if aq.OnCloseCallback then
task.spawn(function()
ag.SafeCallback(aq.OnCloseCallback)
end)
end



aq.UIElements.Main:WaitForChild"Main".Visible=false

aq.CanDropdown=false
aq.Closed=true

aj(aq.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
if aq.UIElements.BackgroundGradient then
aj(aq.UIElements.BackgroundGradient,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

aj(aq.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,-240),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()


if b then
if b:IsA"VideoFrame"then
b.Visible=false
else
aj(b,0.3,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
aj(aw,0.25,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
aj(UIStroke,0.25,{Transparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

aj(h,.3,{Size=UDim2.new(0,0,0,4),ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()
aj(at.ImageLabel,.3,{ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
m:Set(false)
aq.CanResize=false

task.spawn(function()
task.wait(0.4)
aq.UIElements.Main.Visible=false
end)

function v.Destroy(x)
if aq.OnDestroyCallback then
task.spawn(function()
ag.SafeCallback(aq.OnDestroyCallback)
end)
end



aq.Destroyed=true
task.wait(0.4)
ap.WindUI.ScreenGui:Destroy()
ap.WindUI.NotificationGui:Destroy()
ap.WindUI.DropdownGui:Destroy()


end

return v
end
function aq.Destroy(u)
return aq:Close():Destroy()
end
function aq.Toggle(u)
if aq.Closed then
aq:Open()
else
aq:Close()
end
end


function aq.ToggleTransparency(u,v)

aq.Transparent=v
ap.WindUI.Transparent=v

aq.UIElements.Main.Background.ImageTransparency=v and ap.WindUI.TransparencyValue or 0

aq.UIElements.MainBar.Background.ImageTransparency=v and 0.97 or 0.95

end

function aq.LockAll(u)
for v,x in next,aq.AllElements do
if x.Lock then x:Lock()end
end
end
function aq.UnlockAll(u)
for v,x in next,aq.AllElements do
if x.Unlock then x:Unlock()end
end
end
function aq.GetLocked(u)
local v={}

for x,z in next,aq.AllElements do
if z.Locked then table.insert(v,z)end
end

return v
end
function aq.GetUnlocked(u)
local v={}

for x,z in next,aq.AllElements do
if z.Locked==false then table.insert(v,z)end
end

return v
end

function aq.GetUIScale(u,v)
return ap.WindUI.UIScale
end

function aq.SetUIScale(u,v)
ap.WindUI.UIScale=v
aj(ap.WindUI.ScreenGui.UIScale,.2,{Scale=v},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return aq
end

function aq.SetToTheCenter(u)
aj(aq.UIElements.Main,0.45,{Position=UDim2.new(0.5,0,0.5,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return aq
end

do
local u=40
local v=ae.ViewportSize
local x=aq.UIElements.Main.AbsoluteSize

if not aq.IsFullscreen and aq.AutoScale then
local z=v.X-(u*2)
local A=v.Y-(u*2)

local B=z/x.X
local C=A/x.Y

local F=math.min(B,C)

local G=0.3
local H=1.0

local J=math.clamp(F,G,H)

local L=aq:GetUIScale()or 1
local M=0.05

if math.abs(J-L)>M then
aq:SetUIScale(J)
end
end
end


if aq.OpenButtonMain and aq.OpenButtonMain.Button then
ag.AddSignal(aq.OpenButtonMain.Button.TextButton.MouseButton1Click,function()

aq.OpenButtonMain:Visible(false)
aq:Open()
end)
end

ag.AddSignal(ac.InputBegan,function(u,v)
if v then return end

if aq.ToggleKey then
if u.KeyCode==aq.ToggleKey then
aq:Toggle()
end
end
end)

task.spawn(function()

aq:Open()
end)

function aq.EditOpenButton(u,v)
return aq.OpenButtonMain:Edit(v)
end

if aq.OpenButton and typeof(aq.OpenButton)=="table"then
aq:EditOpenButton(aq.OpenButton)
end


local u=a.load'S'
local v=a.load'T'
local x=u.Init(aq,ap.WindUI,ap.Parent.Parent.ToolTips)
x:OnChange(function(z)aq.CurrentTab=z end)

aq.TabModule=u

function aq.Tab(z,A)
A.Parent=aq.UIElements.SideBar.Frame
return x.New(A,ap.WindUI.UIScale)
end

function aq.SelectTab(z,A)
x:SelectTab(A)
end

function aq.Section(z,A)
return v.New(A,aq.UIElements.SideBar.Frame,aq.Folder,ap.WindUI.UIScale,aq)
end

function aq.IsResizable(z,A)
aq.Resizable=A
aq.CanResize=A
end

function aq.Divider(z)
local A=ai("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local B=ai("Frame",{
Parent=aq.UIElements.SideBar.Frame,

Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
A
})

return B
end

local z=a.load'k'.Init(aq,nil)
function aq.Dialog(A,B)
local C={
Title=B.Title or"Dialog",
Width=B.Width or 320,
Content=B.Content,
Buttons=B.Buttons or{},

TextPadding=10,
}
local F=z.Create(false)

F.UIElements.Main.Size=UDim2.new(0,C.Width,0,0)

local G=ai("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=F.UIElements.Main
},{
ai("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,F.UIPadding),
VerticalAlignment="Center"
}),
ai("UIPadding",{
PaddingTop=UDim.new(0,C.TextPadding/2),
PaddingLeft=UDim.new(0,C.TextPadding/2),
PaddingRight=UDim.new(0,C.TextPadding/2),
})
})

local H
if B.Icon then
H=ag.Image(
B.Icon,
C.Title..":"..B.Icon,
0,
aq,
"Dialog",
true,
B.IconThemed
)
H.Size=UDim2.new(0,22,0,22)
H.Parent=G
end

F.UIElements.UIListLayout=ai("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
Parent=F.UIElements.Main
})

ai("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=F.UIElements.Main,
})


F.UIElements.Title=ai("TextLabel",{
Text=C.Title,
TextSize=20,
FontFace=Font.new(ag.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,H and-26-F.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=G
})
if C.Content then
ai("TextLabel",{
Text=C.Content,
TextSize=18,
TextTransparency=.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(ag.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=F.UIElements.Main
},{
ai("UIPadding",{
PaddingLeft=UDim.new(0,C.TextPadding/2),
PaddingRight=UDim.new(0,C.TextPadding/2),
PaddingBottom=UDim.new(0,C.TextPadding/2),
})
})
end

local J=ai("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
})

local L=ai("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=F.UIElements.Main,
LayoutOrder=4,
},{
J,






})


local M={}

for N,O in next,C.Buttons do
local P=al(O.Title,O.Icon,O.Callback,O.Variant,L,F,false)
table.insert(M,P)
end

local function CheckButtonsOverflow()
J.FillDirection=Enum.FillDirection.Horizontal
J.HorizontalAlignment=Enum.HorizontalAlignment.Right
J.VerticalAlignment=Enum.VerticalAlignment.Center
L.AutomaticSize=Enum.AutomaticSize.None

for N,O in ipairs(M)do
O.Size=UDim2.new(0,0,1,0)
O.AutomaticSize=Enum.AutomaticSize.X
end

wait()

local N=J.AbsoluteContentSize.X/ap.WindUI.UIScale
local O=L.AbsoluteSize.X/ap.WindUI.UIScale

if N>O then
J.FillDirection=Enum.FillDirection.Vertical
J.HorizontalAlignment=Enum.HorizontalAlignment.Right
J.VerticalAlignment=Enum.VerticalAlignment.Bottom
L.AutomaticSize=Enum.AutomaticSize.Y

for P,Q in ipairs(M)do
Q.Size=UDim2.new(1,0,0,40)
Q.AutomaticSize=Enum.AutomaticSize.None
end
else
local P=O-N
if P>0 then
local Q
local R=math.huge

for S,T in ipairs(M)do
local U=T.AbsoluteSize.X/ap.WindUI.UIScale
if U<R then
R=U
Q=T
end
end

if Q then
Q.Size=UDim2.new(0,R+P,1,0)
Q.AutomaticSize=Enum.AutomaticSize.None
end
end
end
end

ag.AddSignal(F.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",CheckButtonsOverflow)
CheckButtonsOverflow()

wait()
F:Open()

return F
end


aq:CreateTopbarButton("Close","x",function()
aq:SetToTheCenter()
aq:Dialog{

Title="Close Window",
Content="Do you want to close this window? You will not be able to open it again.",
Buttons={
{
Title="Cancel",

Callback=function()end,
Variant="Secondary",
},
{
Title="Close Window",

Callback=function()aq:Close():Destroy()end,
Variant="Primary",
}
}
}
end,999)

function aq.Tag(A,B)
if aq.UIElements.Main.Main.Topbar.Center.Visible==false then aq.UIElements.Main.Main.Topbar.Center.Visible=true end
return an:New(B,aq.UIElements.Main.Main.Topbar.Center)
end


local function startResizing(A)
if aq.CanResize then
isResizing=true
au.Active=true
initialSize=aq.UIElements.Main.Size
initialInputPosition=A.Position


aj(at.ImageLabel,0.1,{ImageTransparency=.35}):Play()

ag.AddSignal(A.Changed,function()
if A.UserInputState==Enum.UserInputState.End then
isResizing=false
au.Active=false


aj(at.ImageLabel,0.17,{ImageTransparency=.8}):Play()
end
end)
end
end

ag.AddSignal(at.InputBegan,function(A)
if A.UserInputType==Enum.UserInputType.MouseButton1 or A.UserInputType==Enum.UserInputType.Touch then
if aq.CanResize then
startResizing(A)
end
end
end)

ag.AddSignal(ac.InputChanged,function(A)
if A.UserInputType==Enum.UserInputType.MouseMovement or A.UserInputType==Enum.UserInputType.Touch then
if isResizing and aq.CanResize then
local B=A.Position-initialInputPosition
local C=UDim2.new(0,initialSize.X.Offset+B.X*2,0,initialSize.Y.Offset+B.Y*2)

C=UDim2.new(
C.X.Scale,
math.clamp(C.X.Offset,aq.MinSize.X,aq.MaxSize.X),
C.Y.Scale,
math.clamp(C.Y.Offset,aq.MinSize.Y,aq.MaxSize.Y)
)

aj(aq.UIElements.Main,0,{
Size=C
}):Play()

aq.Size=C
end
end
end)




local A=0
local B=0.4
local C
local F=0

function onDoubleClick()
aq:SetToTheCenter()
end

h.Frame.MouseButton1Up:Connect(function()
local G=tick()
local H=aq.Position

F=F+1

if F==1 then
A=G
C=H

task.spawn(function()
task.wait(B)
if F==1 then
F=0
C=nil
end
end)

elseif F==2 then
if G-A<=B and H==C then
onDoubleClick()
end

F=0
C=nil
A=0
else
F=1
A=G
C=H
end
end)





if not aq.HideSearchBar then
local G=a.load'V'
local H=false





















local J=ak("Search","search",aq.UIElements.SideBarContainer,true)
J.Size=UDim2.new(1,-aq.UIPadding/2,0,39)
J.Position=UDim2.new(0,aq.UIPadding/2,0,aq.UIPadding/2)

ag.AddSignal(J.MouseButton1Click,function()
if H then return end

G.new(aq.TabModule,aq.UIElements.Main,function()

H=false
if aq.Resizable then
aq.CanResize=true
end

aj(av,0.1,{ImageTransparency=1}):Play()
av.Active=false
end)
aj(av,0.1,{ImageTransparency=.65}):Play()
av.Active=true

H=true
aq.CanResize=false
end)
end




function aq.DisableTopbarButtons(G,H)
for J,L in next,H do
for M,N in next,aq.TopBarButtons do
if N.Name==L then
N.Object.Visible=false
end
end
end
end

return aq
end end end
local ac={
Window=nil,
Theme=nil,
Creator=a.load'a',
LocalizationModule=a.load'b',
NotificationModule=a.load'c',
Themes=nil,
Transparent=false,

TransparencyValue=.15,

UIScale=1,


Version="0.0.0",

Services=a.load'g',

OnThemeChangeFunction=nil,
}


local ae=game:GetService"HttpService"


local ag=ae:JSONDecode(a.load'h')
if ag then
ac.Version=ag.version
end

local ai=a.load'l'local aj=

ac.Services

local ak=ac.Creator

local al=ak.New local am=
ak.Tween


local an=a.load'p'local ao=

game:GetService"Players"and game:GetService"Players".LocalPlayer or nil

local ap=protectgui or(syn and syn.protect_gui)or function()end

local aq=gethui and gethui()or(game.CoreGui or game.Players.LocalPlayer:WaitForChild"PlayerGui")


ac.ScreenGui=al("ScreenGui",{
Name="WindUI",
Parent=aq,
IgnoreGuiInset=true,
ScreenInsets="None",
},{
al("UIScale",{
Scale=ac.Scale,
}),
al("Folder",{
Name="Window"
}),






al("Folder",{
Name="KeySystem"
}),
al("Folder",{
Name="Popups"
}),
al("Folder",{
Name="ToolTips"
})
})

ac.NotificationGui=al("ScreenGui",{
Name="WindUI/Notifications",
Parent=aq,
IgnoreGuiInset=true,
})
ac.DropdownGui=al("ScreenGui",{
Name="WindUI/Dropdowns",
Parent=aq,
IgnoreGuiInset=true,
})
ap(ac.ScreenGui)
ap(ac.NotificationGui)
ap(ac.DropdownGui)

ak.Init(ac)

math.clamp(ac.TransparencyValue,0,1)

local ar=ac.NotificationModule.Init(ac.NotificationGui)

function ac.Notify(as,at)
at.Holder=ar.Frame
at.Window=ac.Window

return ac.NotificationModule.New(at)
end

function ac.SetNotificationLower(as,at)
ar.SetLower(at)
end

function ac.SetFont(as,at)
ak.UpdateFont(at)
end

function ac.OnThemeChange(as,at)
ac.OnThemeChangeFunction=at
end

function ac.AddTheme(as,at)
ac.Themes[at.Name]=at
return at
end

function ac.SetTheme(as,at)
if ac.Themes[at]then
ac.Theme=ac.Themes[at]
ak.SetTheme(ac.Themes[at])

if ac.OnThemeChangeFunction then
ac.OnThemeChangeFunction(at)
end


return ac.Themes[at]
end
return nil
end

function ac.GetThemes(as)
return ac.Themes
end
function ac.GetCurrentTheme(as)
return ac.Theme.Name
end
function ac.GetTransparency(as)
return ac.Transparent or false
end
function ac.GetWindowSize(as)
return Window.UIElements.Main.Size
end
function ac.Localization(as,at)
return ac.LocalizationModule:New(at,ak)
end

function ac.SetLanguage(as,at)
if ak.Localization then
return ak.SetLanguage(at)
end
return false
end

function ac.ToggleAcrylic(as,at)
if ac.Window and ac.Window.AcrylicPaint and ac.Window.AcrylicPaint.Model then
ac.Window.Acrylic=at
ac.Window.AcrylicPaint.Model.Transparency=at and 0.98 or 1
if at then
an.Enable()
else
an.Disable()
end
end
end



function ac.Gradient(as,at,au)
local av={}
local aw={}

for ax,ay in next,at do
local az=tonumber(ax)
if az then
az=math.clamp(az/100,0,1)
table.insert(av,ColorSequenceKeypoint.new(az,ay.Color))
table.insert(aw,NumberSequenceKeypoint.new(az,ay.Transparency or 0))
end
end

table.sort(av,function(ax,ay)return ax.Time<ay.Time end)
table.sort(aw,function(ax,ay)return ax.Time<ay.Time end)


if#av<2 then
error"ColorSequence requires at least 2 keypoints"
end


local ax={
Color=ColorSequence.new(av),
Transparency=NumberSequence.new(aw),
}

if au then
for ay,az in pairs(au)do
ax[ay]=az
end
end

return ax
end


function ac.Popup(as,at)
at.WindUI=ac
return a.load'q'.new(at)
end


ac.Themes=a.load'r'(ac)

ak.Themes=ac.Themes


ac:SetTheme"Dark"
ac:SetLanguage(ak.Language)


function ac.CreateWindow(as,at)
local au=a.load'W'

if not isfolder"WindUI"then
makefolder"WindUI"
end
if at.Folder then
makefolder(at.Folder)
else
makefolder(at.Title)
end

at.WindUI=ac
at.Parent=ac.ScreenGui.Window

if ac.Window then
warn"You cannot create more than one window"
return
end

local av=true

local aw=ac.Themes[at.Theme or"Dark"]


ak.SetTheme(aw)


local ax=gethwid or function()
return game:GetService"Players".LocalPlayer.UserId
end

local ay=ax()

if at.KeySystem then
av=false

local function loadKeysystem()
ai.new(at,ay,function(az)av=az end)
end

local az=at.Folder.."/"..ay..".key"

if not at.KeySystem.API then
if at.KeySystem.SaveKey and isfile(az)then
local aA=readfile(az)
local b=(type(at.KeySystem.Key)=="table")
and table.find(at.KeySystem.Key,aA)
or tostring(at.KeySystem.Key)==tostring(aA)

if b then
av=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
if isfile(az)then
local aA=readfile(az)
local b=false

for e,g in next,at.KeySystem.API do
local h=ac.Services[g.Type]
if h then
local i={}
for j,l in next,h.Args do
table.insert(i,g[l])
end

local j=h.New(table.unpack(i))
local l=j.Verify(aA)
if l then
b=true
break
end
end
end

av=b
if not b then loadKeysystem()end
else
loadKeysystem()
end
end

repeat task.wait()until av
end

local az=au(at)

ac.Transparent=at.Transparent
ac.Window=az

if at.Acrylic then
an.init()
end













return az
end

return ac