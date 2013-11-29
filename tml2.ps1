function slice
{
    param ([String]$word);

    $arr = New-Object System.Collections.Generic.List[System.String]

    $i = 0;
    while ($i -lt $word.Length)
    {
        if ($i -lt ($word.Length - 2) -and $word[$i + 1] -eq '~')
        {
            $arr.Add($word.Substring($i, 3));
            $i += 3;
        }
        else
        {
            $arr.Add($word.Substring($i, 1));
            $i++;
        }
    }

    return $arr
}

function cutWord
{
    param ($word, $of = "");
    
    $fn = slice "cfhjsvxyzmn";
    $c = slice "bdgklprtw";
    $a = slice "d~zd~jt~st~c^";
    $v = slice "aeiouq-`$?`'/";

    $erassocs = @{
    '"' = 'k';
    '!' = 'p';
    '*' = 'c';
    '#' = 'm';
    ':' = 'x';
    };

    [System.Collections.Generic.List[System.String]]$w = slice $word;

    $i = 0;
    while ($i -lt $w.Count)
    {
        if ($erassocs.ContainsKey($w[$i]))
        {
            $w[$i] = $erassocs[$w[$i]];
        }
        $i++;
    }

    if ($w[0] -in $fn -or $w[0] -in $a)
    {
        $w.Insert(0, '?')
    }
    $li = $w.Count - 1;
    if ($w[$li] -in $c)
    {
        $w.Add('?')
    }

    # schwas inplace

    [System.Collections.Generic.List[System.String]]$res = New-Object System.Collections.Generic.List[System.String]

    $i = 0;
    $cur = "";
    while ($i -lt $w.Count)
    {
        $cur += $w[$i];
        if ($w[$i] -in $v)
        {
            if (!($w.Count -gt $i + 1 -and ($w[$i + 1] -in $fn -or $w[$i + 1] -in $a)))
            {
                $res.Add($cur);
                $cur = "";
            }
        }
        else
        {
            if ($w[$i] -in $fn -or $w[$i] -in $a)
            {
                $res.Add($cur);
                $cur = "";
            }
        }
        $i++;
    }

    if ($cur -ne "")
    {
        $res.Add($cur);
    }

    switch ($of)
    {
        "csv" { $res = [string]::Join(",", $res.ToArray()); break; }
    }

    return $res;
}

function cut
{
    param($of = "");

    [System.Collections.Generic.List[System.String]]$res = New-Object System.Collections.Generic.List[System.String]

    $input | % { $_.Split(' ') | % -begin { $i = 0; } { if ($i -ne 0) { $res.Add(" ") }; cutWord $_ | % { $res.Add($_) }; $i++ } }
    
    switch ($of)
    {
        "csv" { $res = [string]::Join(",", $res.ToArray()); break; }
    }

    return $res;
}
