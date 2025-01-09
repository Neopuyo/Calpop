# Calpop : the compute machine

![Wide View](readme_img/key-banner.png)

## Project overview

**`Calpop`** is an iOS app that offers a calculator. It's a rather classic training project for honing skills, written in **SwiftUI**.  

![Wide View](readme_img/xcode-wide-view.png)

## Expression third party library

The [Expression Framework](https://github.com/nicklockwood/Expression) is easily integrated into the project using **Swift Package Manager**.

<table style="border: 0px;">
    <tr>
        <td >
        <div style="border-radius:12px; overflow:hidden;"> 
            <img src="./readme_img/expression-spm.png" alt="Explore SPM" style="width: 280px;">
            </div>
        </td>
        <td>
            <div style="margin-left: 20px; width:260px;">
                <h2><b>Expression Framework</b></h2>
                <p> Used for parsing and evaluate mathematical expression in Calpop project.</p>
            </div>
        </td>
    </tr>
</table>

<br/>

## Design

<table style="border: 0px;">
    <tr>
        <td>
            <div style="margin-right: 20px; width:260px;">
                <h2><b>Let's talk about design</b></h2>
                <p> A focus on achieving a <b>design</b> that is both functional and visually appealing, using a mockup created beforehand with <b>Sketch</b>.</p>
            </div>
        </td>
        <td>
        	<div style="border-radius:12px; overflow:hidden;"> 
            <img src="./readme_img/design.gif" alt="design use demo" style="width: 280px;">
           </div>
        </td>
    </tr>
</table>

## Real calclulator behaviour

Functionality inspired by a mix of the behaviors of calculators provided by macOS and Windows. The goal is to properly handle the **chaining of multiple calculations**. 

![Chain compute](readme_img/chain-compute.png)

## Classic memory features

No button is decorative. The **memory functions** triggered by the yellow buttons are fully operational.

<table style="border: 0px;">
    <tr style="text-align:center;">
        <td>
        	<b>
            <span style=color:yellow;>MS</span>  
            Save memo entry
            </b>
        </td>
        <td>
        	<b>
            <span style=color:yellow;>Mv</span>  
            Select current memo 
            </b>
        </td>
        <td>
        	<b>
            <span style=color:yellow;>MR</span>   
            Recall current memo
            </b>
        </td>
    </tr>
    <tr>
        <td>
        	<div style="border-radius:12px; overflow:hidden;"> 
            <img src="./readme_img/memo1.png" alt="design use demo" style="width: 240px;">
           </div>
        </td>
        <td>
        	<div style="border-radius:12px; overflow:hidden;"> 
            <img src="./readme_img/memo2.png" alt="design use demo" style="width: 240px;">
           </div>
        </td>
        <td>
        	<div style="border-radius:12px; overflow:hidden;"> 
            <img src="./readme_img/memo.gif" alt="design use demo" style="width: 240px;">
           </div>
        </td>
    </tr>
</table>

## Model architechture

<table style="border: 0px;">
    <tr>
        <td >
        <div style="border-radius:12px; overflow:hidden;"> 
            <img src="./readme_img/model.png" alt="Model Architecture" style="width: 480px;">
            </div>
        </td>
        <td>
            <div style="margin-left: 20px; width:260px;">
                <h2><b>Split responsabilities</b></h2>
                <p>From a <b>model architecture</b> perspective, I aimed to separate each feature into distinct classes, which are then all utilized by the main model through <b>dependency injection</b>.</p>
            </div>
        </td>
    </tr>
</table>

<br/>